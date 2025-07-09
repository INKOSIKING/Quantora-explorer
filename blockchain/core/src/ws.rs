use actix::{Actor, StreamHandler, Addr, Context, AsyncContext};
use actix_web_actors::ws;
use actix_web::{web, HttpRequest, HttpResponse, Error};
use std::time::{Duration, Instant};
use serde::{Serialize, Deserialize};
use tracing::info;

#[derive(Serialize, Deserialize)]
pub enum WsEvent {
    BlockMined { hash: String, height: u64 },
    Transaction { tx_id: String, status: String },
    ContractEvent { contract: String, log: String },
}

pub struct WsSession {
    pub hb: Instant,
    pub event_rx: tokio::sync::mpsc::UnboundedReceiver<WsEvent>,
}

impl Actor for WsSession {
    type Context = ws::WebsocketContext<Self>;

    fn started(&mut self, ctx: &mut Self::Context) {
        self.hb(ctx);
        // Spawn event forwarder
        let rx = self.event_rx.take();
        if let Some(mut rx) = rx {
            ctx.spawn(async move {
                while let Some(event) = rx.recv().await {
                    let msg = serde_json::to_string(&event).unwrap();
                    ctx.text(msg);
                }
            });
        }
    }
}

impl WsSession {
    fn hb(&self, ctx: &mut ws::WebsocketContext<Self>) {
        ctx.run_interval(Duration::from_secs(5), |act, ctx| {
            if Instant::now().duration_since(act.hb) > Duration::from_secs(10) {
                ctx.stop();
                return;
            }
            ctx.ping(b"heartbeat");
        });
    }
}

impl StreamHandler<Result<ws::Message, ws::ProtocolError>> for WsSession {
    fn handle(&mut self, msg: Result<ws::Message, ws::ProtocolError>, ctx: &mut Self::Context) {
        match msg {
            Ok(ws::Message::Ping(msg)) => {
                self.hb = Instant::now();
                ctx.pong(&msg);
            }
            Ok(ws::Message::Pong(_)) => {
                self.hb = Instant::now();
            }
            Ok(ws::Message::Text(_)) => {
                // Ignore, or implement subscription filtering if needed
            }
            Ok(ws::Message::Close(_)) => {
                ctx.stop();
            }
            _ => {}
        }
    }
}

// Shared event broadcaster
use tokio::sync::broadcast::{self, Sender};
use once_cell::sync::Lazy;

pub static WS_EVENT_BROADCASTER: Lazy<Sender<WsEvent>> = Lazy::new(|| broadcast::channel(1024).0);

pub async fn ws_index(r: HttpRequest, stream: web::Payload) -> Result<HttpResponse, Error> {
    let rx = WS_EVENT_BROADCASTER.subscribe();
    let (event_tx, event_rx) = tokio::sync::mpsc::unbounded_channel();
    tokio::spawn(async move {
        let mut rx = rx;
        while let Ok(event) = rx.recv().await {
            let _ = event_tx.send(event);
        }
    });
    ws::start(
        WsSession {
            hb: Instant::now(),
            event_rx,
        },
        &r,
        stream,
    )
}