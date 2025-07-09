use std::collections::HashSet;
use std::net::{SocketAddr, TcpListener, TcpStream};
use std::sync::{Arc, Mutex};
use std::thread;
use std::io::{Read, Write};

const HANDSHAKE_MSG: &str = "QTA_NODE_HANDSHAKE";
const MAX_PEERS: usize = 64;

#[derive(Clone)]
pub struct Peer {
    pub address: SocketAddr,
}

#[derive(Clone)]
pub struct PeerSet {
    peers: Arc<Mutex<HashSet<SocketAddr>>>,
}

impl PeerSet {
    pub fn new() -> Self {
        PeerSet {
            peers: Arc::new(Mutex::new(HashSet::new())),
        }
    }

    pub fn add_peer(&self, addr: SocketAddr) {
        let mut peers = self.peers.lock().unwrap();
        if peers.len() < MAX_PEERS {
            peers.insert(addr);
        }
    }

    pub fn remove_peer(&self, addr: &SocketAddr) {
        let mut peers = self.peers.lock().unwrap();
        peers.remove(addr);
    }

    pub fn get_peers(&self) -> Vec<SocketAddr> {
        let peers = self.peers.lock().unwrap();
        peers.iter().cloned().collect()
    }

    pub fn contains(&self, addr: &SocketAddr) -> bool {
        let peers = self.peers.lock().unwrap();
        peers.contains(addr)
    }
}

/// Start peer discovery thread (listens for incoming connections)
pub fn start_peer_listener(peer_set: PeerSet, bind_addr: SocketAddr) {
    let listener = TcpListener::bind(bind_addr).expect("Failed to bind peer listener");
    println!("Peer listener running on {}", bind_addr);

    thread::spawn(move || {
        for stream in listener.incoming() {
            match stream {
                Ok(mut s) => {
                    let mut buf = [0; 64];
                    if let Ok(n) = s.read(&mut buf) {
                        let msg = String::from_utf8_lossy(&buf[..n]);
                        if msg == HANDSHAKE_MSG {
                            if let Ok(peer_addr) = s.peer_addr() {
                                println!("Peer connected: {}", peer_addr);
                                peer_set.add_peer(peer_addr);
                            }
                        }
                    }
                }
                Err(e) => eprintln!("Peer connection error: {:?}", e),
            }
        }
    });
}

/// Attempt to connect to a peer (outbound)
pub fn connect_to_peer(peer_set: PeerSet, addr: SocketAddr) -> bool {
    if peer_set.contains(&addr) {
        return false;
    }
    match TcpStream::connect(addr) {
        Ok(mut stream) => {
            let _ = stream.write_all(HANDSHAKE_MSG.as_bytes());
            println!("Connected to peer: {}", addr);
            peer_set.add_peer(addr);
            true
        }
        Err(e) => {
            eprintln!("Failed to connect to peer {}: {:?}", addr, e);
            false
        }
    }
}

/// Broadcast data to all peers
pub fn broadcast(peer_set: &PeerSet, data: &[u8]) {
    for peer_addr in peer_set.get_peers() {
        if let Ok(mut stream) = TcpStream::connect(peer_addr) {
            let _ = stream.write_all(data);
        }
    }
}