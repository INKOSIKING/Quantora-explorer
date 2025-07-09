use std::sync::{Arc, Mutex};
use std::net::TcpListener;
use std::io::{Read, Write};
use crate::storage::Storage;

pub struct RpcServer {
    storage: Arc<Mutex<Storage>>,
}

impl RpcServer {
    pub fn new(storage: Arc<Mutex<Storage>>) -> Self {
        RpcServer { storage }
    }

    pub fn start(&self, addr: &str) {
        let listener = TcpListener::bind(addr).expect("Failed to bind RPC server");
        for stream in listener.incoming() {
            match stream {
                Ok(mut s) => {
                    let mut buf = [0u8; 4096];
                    let len = s.read(&mut buf).unwrap_or(0);
                    if len > 0 {
                        // For demonstration: expect request as "get_block:HEIGHT"
                        let req = String::from_utf8_lossy(&buf[0..len]);
                        if req.starts_with("get_block:") {
                            if let Ok(height) = req[10..].trim().parse::<u64>() {
                                let storage = self.storage.lock().unwrap();
                                if let Some(block) = storage.get_block_by_height(height) {
                                    let _ = s.write_all(serde_json::to_string(&block).unwrap().as_bytes());
                                }
                            }
                        }
                    }
                }
                Err(e) => eprintln!("RPC error: {:?}", e),
            }
        }
    }
}