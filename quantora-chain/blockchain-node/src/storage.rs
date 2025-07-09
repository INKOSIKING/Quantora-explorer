use serde::{Serialize, Deserialize};
use std::collections::BTreeMap;
use std::fs::{File, OpenOptions};
use std::io::{Read, Write};
use std::path::Path;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Block {
    pub height: u64,
    pub hash: String,
    pub prev_hash: String,
    pub timestamp: u64,
    pub txs: Vec<String>,
    pub nonce: u64,
}

pub struct Storage {
    path: String,
    blocks: BTreeMap<u64, Block>,
}

impl Storage {
    pub fn new<P: AsRef<Path>>(path: P) -> Self {
        let mut blocks = BTreeMap::new();
        let storage_path = path.as_ref().to_str().unwrap().to_string();
        let file_path = format!("{}/blocks.db", storage_path);
        if let Ok(mut file) = File::open(&file_path) {
            let mut buf = Vec::new();
            file.read_to_end(&mut buf).unwrap();
            if !buf.is_empty() {
                blocks = bincode::deserialize(&buf).unwrap_or(BTreeMap::new());
            }
        }
        Storage { path: storage_path, blocks }
    }

    pub fn save_block(&mut self, block: &Block) -> std::io::Result<()> {
        self.blocks.insert(block.height, block.clone());
        let file_path = format!("{}/blocks.db", self.path);
        let mut file = OpenOptions::new().write(true).create(true).open(&file_path)?;
        let buf = bincode::serialize(&self.blocks).unwrap();
        file.write_all(&buf)?;
        Ok(())
    }

    pub fn get_block_by_height(&self, height: u64) -> Option<&Block> {
        self.blocks.get(&height)
    }
}