use criterion::{criterion_group, criterion_main, Criterion};
use quantora_chain::storage::Block;
use quantora_chain::consensus::Consensus;
use quantora_chain::storage::Storage;
use std::sync::{Arc, Mutex};

fn bench_block_mining(c: &mut Criterion) {
    let tmp_dir = tempfile::tempdir().unwrap();
    let storage = Arc::new(Mutex::new(Storage::new(tmp_dir.path())));
    let consensus = Consensus::new(storage.clone(), 2);

    let txs = vec!["tx1".to_string(), "tx2".to_string(), "tx3".to_string()];

    c.bench_function("mine_block", |b| {
        b.iter(|| {
            let _ = consensus.mine_block(txs.clone());
        })
    });
}

fn bench_block_save_load(c: &mut Criterion) {
    let tmp_dir = tempfile::tempdir().unwrap();
    let mut storage = Storage::new(tmp_dir.path());

    let block = Block {
        height: 1,
        hash: "abc123".to_string(),
        prev_hash: "0".repeat(64),
        timestamp: 1234567890,
        txs: vec!["tx1".to_string(), "tx2".to_string()],
        nonce: 42,
    };

    c.bench_function("save_block", |b| {
        b.iter(|| {
            storage.save_block(&block).unwrap();
        })
    });

    storage.save_block(&block).unwrap();
    c.bench_function("get_block_by_height", |b| {
        b.iter(|| {
            let _ = storage.get_block_by_height(1);
        })
    });
}

criterion_group!(benches, bench_block_mining, bench_block_save_load);
criterion_main!(benches);