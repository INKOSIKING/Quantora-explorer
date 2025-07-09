use actix::prelude::*;
use actix_web_actors::ws;
use serde_json::json;
use crate::mempool::SharedMempool;

pub struct MempoolWs {
    mempool: SharedMempool,
}

impl Actor for MempoolWs {
    type Context = ws::WebsocketContext<Self>;
    fn started(&mut self, ctx: &mut Self::Context) {
        let addr = ctx.address();
        // Subscribe to mempool updates (broadcast channel or similar)
        self.mempool.subscribe(Box::new(move |tx| {
            addr.do_send(ws::Message::Text(serde_json::to_string(&tx).unwrap()));
        }));
    }
}

impl StreamHandler<Result<ws::Message, ws::ProtocolError>> for MempoolWs {
    fn handle(&mut self, msg: Result<ws::Message, ws::ProtocolError>, ctx: &mut Self::Context) {
        if let Ok(ws::Message::Text(_)) = msg {
            // No-op: Push only
        }
    }
}

// Endpoint
pub async fn mempool_ws(
    mempool: web::Data<SharedMempool>,
    req: HttpRequest,
    stream: web::Payload,
) -> Result<HttpResponse, Error> {
    ws::start(MempoolWs { mempool: mempool.get_ref().clone() }, &req, stream)
}