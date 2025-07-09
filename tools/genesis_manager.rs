use std::fs::File;
use std::io::{Read, Write};
use serde_json::Value;
use ring::signature::{Ed25519KeyPair, KeyPair, Signature, ED25519_PUBLIC_KEY_LEN};
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    match args.get(1).map(String::as_str) {
        Some("validate") => validate_genesis(&args[2]),
        Some("sign") => sign_genesis(&args[2], &args[3]),
        Some("generate") => generate_genesis(&args[2]),
        _ => eprintln!("Usage: genesis_manager [validate|sign|generate] <file> [key]"),
    }
}

fn validate_genesis(path: &str) {
    let mut file = File::open(path).expect("Cannot open genesis file");
    let mut contents = String::new();
    file.read_to_string(&mut contents).expect("Cannot read genesis file");
    let v: Value = serde_json::from_str(&contents).expect("Genesis not valid JSON");
    assert!(v.get("chainId").is_some(), "chainId missing");
    assert!(v.get("alloc").is_some(), "alloc missing");
    println!("Genesis file {} is valid.", path);
}

fn sign_genesis(path: &str, key_path: &str) {
    let mut file = File::open(path).expect("Cannot open genesis file");
    let mut contents = Vec::new();
    file.read_to_end(&mut contents).expect("Cannot read genesis file");
    let key_bytes = std::fs::read(key_path).expect("Cannot read key file");
    let key_pair = Ed25519KeyPair::from_seed_unchecked(&key_bytes).expect("Invalid key");
    let sig = key_pair.sign(&contents);
    let mut sig_file = File::create(format!("{}.sig", path)).expect("Cannot create sig file");
    sig_file.write_all(sig.as_ref()).expect("Cannot write sig");
    println!("Genesis signed. Signature written to {}.sig", path);
}

fn generate_genesis(out_path: &str) {
    let genesis = r#"{
        "chainId": 1001,
        "alloc": {},
        "config": { "homesteadBlock": 0, "eip155Block": 0 },
        "difficulty": "0x40000",
        "gasLimit": "0x8000000"
    }"#;
    let mut file = File::create(out_path).expect("Cannot create genesis file");
    file.write_all(genesis.as_bytes()).expect("Cannot write genesis file");
    println!("Genesis file written to {}", out_path);
}