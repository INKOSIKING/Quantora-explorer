
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
