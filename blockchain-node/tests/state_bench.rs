#![cfg(test)]
#![feature(test)]
extern crate test;
use blockchain_node::state::State;
use blockchain_node::blockchain::{Block, BlockHeader, Transaction};
use test::Bencher;
use rayon::prelude::*;

fn make_tx(from: &str, to: &str, value: u64, nonce: u64) -> Transaction {
    Transaction {
        from: from.to_string(),
        to: to.to_string(),
        value,
        nonce,
        signature: "sig".to_string(),
        data: vec![],
    }
}

#[bench]
fn bench_apply_block_10m(b: &mut Bencher) {
    let state = State::new();
    let miner = "miner";
    let mut txs = Vec::with_capacity(10_000_000);
    for i in 0..10_000_000u64 {
        let from = format!("user{}", i);
        let to = format!("user{}", i+1);
        txs.push(make_tx(&from, &to, 1, 0));
        // Pre-fund sender
        state.apply_transaction(&Transaction::genesis_mint(&from, 1)).unwrap();
    }
    let block = Block {
        header: BlockHeader {
            parent_hash: "parent".to_string(),
            timestamp: 0,
            miner: miner.to_string(),
            nonce: 0,
        },
        transactions: txs,
    };
    b.iter(|| {
        state.apply_block(&block, 0).unwrap();
    });
}

#[bench]
fn bench_parallel_apply_tx_1m(b: &mut Bencher) {
    let state = State::new();
    let users: Vec<String> = (0..1_000_000u64).map(|i| format!("addr{}", i)).collect();
    users.par_iter().for_each(|u| {
        state.apply_transaction(&Transaction::genesis_mint(u, 10)).unwrap();
    });

    let txs: Vec<_> = users.par_iter().map(|u| {
        make_tx(u, "sink", 1, 0)
    }).collect();

    b.iter(|| {
        txs.par_iter().for_each(|tx| {
            state.apply_transaction(tx).unwrap();
        });
    });
}