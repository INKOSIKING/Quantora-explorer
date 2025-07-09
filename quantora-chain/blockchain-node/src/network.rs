use std::collections::HashMap;
use std::net::{TcpListener, TcpStream, SocketAddr};
use std::sync::{Arc, Mutex};
use std::thread;
use std::io::{Read, Write};

pub struct Peer {
    pub addr: SocketAddr,
    pub stream: TcpStream,
}

pub struct Network {
    peers: Arc<Mutex<HashMap<SocketAddr, Peer>>>,
}

impl Network {
    pub fn new() -> Self {
        Network {
            peers: Arc::new(Mutex::new(HashMap::new())),
        }
    }

    pub fn listen(&self, bind_addr: &str) {
        let listener = TcpListener::bind(bind_addr).expect("Failed to bind network listener");
        let peers = Arc::clone(&self.peers);

        thread::spawn(move || {
            for stream in listener.incoming() {
                match stream {
                    Ok(s) => {
                        let addr = s.peer_addr().unwrap();
                        let mut peers_guard = peers.lock().unwrap();
                        peers_guard.insert(addr, Peer { addr, stream: s.try_clone().unwrap() });
                    },
                    Err(e) => eprintln!("Network error: {:?}", e),
                }
            }
        });
    }

    pub fn broadcast(&self, data: &[u8]) {
        let peers_guard = self.peers.lock().unwrap();
        for peer in peers_guard.values() {
            let mut stream = peer.stream.try_clone().unwrap();
            let _ = stream.write_all(data);
        }
    }

    pub fn connect(&self, addr: &str) {
        if let Ok(stream) = TcpStream::connect(addr) {
            let socket_addr = stream.peer_addr().unwrap();
            self.peers.lock().unwrap().insert(socket_addr, Peer { addr: socket_addr, stream });
        }
    }
}