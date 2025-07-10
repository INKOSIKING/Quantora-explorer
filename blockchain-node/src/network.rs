
use tokio::net::{TcpListener, TcpStream};
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use log::{info, error};
use std::sync::Arc;
use tokio::sync::Mutex;

pub struct NetworkManager {
    peers: Arc<Mutex<Vec<String>>>,
}

impl NetworkManager {
    pub fn new() -> Self {
        NetworkManager {
            peers: Arc::new(Mutex::new(Vec::new())),
        }
    }
    
    pub async fn start_listener(&self, addr: &str) -> Result<(), Box<dyn std::error::Error>> {
        let listener = TcpListener::bind(addr).await?;
        info!("Network listening on {}", addr);
        
        loop {
            let (socket, peer_addr) = listener.accept().await?;
            info!("New peer connected: {}", peer_addr);
            
            let peers = self.peers.clone();
            tokio::spawn(async move {
                if let Err(e) = handle_peer(socket, peers).await {
                    error!("Error handling peer {}: {}", peer_addr, e);
                }
            });
        }
    }
    
    pub async fn add_peer(&self, peer_addr: String) {
        let mut peers = self.peers.lock().await;
        if !peers.contains(&peer_addr) {
            peers.push(peer_addr);
        }
    }
    
    pub async fn broadcast_message(&self, message: &str) -> Result<(), Box<dyn std::error::Error>> {
        let peers = self.peers.lock().await;
        for peer_addr in peers.iter() {
            if let Ok(mut stream) = TcpStream::connect(peer_addr).await {
                let _ = stream.write_all(message.as_bytes()).await;
            }
        }
        Ok(())
    }
}

async fn handle_peer(
    mut socket: TcpStream,
    _peers: Arc<Mutex<Vec<String>>>,
) -> Result<(), Box<dyn std::error::Error>> {
    let mut buffer = [0; 1024];
    
    loop {
        let n = socket.read(&mut buffer).await?;
        if n == 0 {
            break;
        }
        
        let message = String::from_utf8_lossy(&buffer[..n]);
        info!("Received message: {}", message);
        
        // Echo back for now
        socket.write_all(b"ACK").await?;
    }
    
    Ok(())
}
use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use tokio::net::{TcpListener, TcpStream};
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use serde::{Serialize, Deserialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum NetworkMessage {
    BlockAnnouncement(crate::blockchain::Block),
    TransactionAnnouncement(crate::blockchain::Transaction),
    PeerDiscovery(String),
    Ping,
    Pong,
}

pub struct NetworkNode {
    pub peers: Arc<Mutex<HashMap<String, TcpStream>>>,
    pub node_id: String,
    pub port: u16,
}

impl NetworkNode {
    pub fn new(port: u16) -> Self {
        Self {
            peers: Arc::new(Mutex::new(HashMap::new())),
            node_id: format!("node_{}", port),
            port,
        }
    }

    pub async fn start(&self) -> Result<(), Box<dyn std::error::Error>> {
        let listener = TcpListener::bind(format!("0.0.0.0:{}", self.port)).await?;
        println!("🌐 Network node listening on port {}", self.port);

        loop {
            let (socket, addr) = listener.accept().await?;
            println!("📡 New peer connected: {}", addr);
            
            let peers = self.peers.clone();
            tokio::spawn(async move {
                Self::handle_peer(socket, peers).await;
            });
        }
    }

    async fn handle_peer(
        mut socket: TcpStream,
        peers: Arc<Mutex<HashMap<String, TcpStream>>>,
    ) {
        let mut buffer = [0; 1024];
        loop {
            match socket.read(&mut buffer).await {
                Ok(0) => break, // Connection closed
                Ok(n) => {
                    let message = String::from_utf8_lossy(&buffer[..n]);
                    println!("📨 Received: {}", message);
                    
                    // Echo back for now
                    if let Err(_) = socket.write_all(b"ACK").await {
                        break;
                    }
                }
                Err(_) => break,
            }
        }
        println!("📡 Peer disconnected");
    }

    pub async fn broadcast_message(&self, message: NetworkMessage) {
        let serialized = serde_json::to_string(&message).unwrap_or_default();
        println!("📢 Broadcasting: {}", serialized);
        // Implementation for broadcasting to all peers
    }
}
