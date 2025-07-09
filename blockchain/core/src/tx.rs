use crate::event::broadcast_transaction;
// ...rest of imports...

pub fn create_transaction(from: String, to: String, amount: i64, nonce: i64, signature: String) -> Transaction {
    let tx = Transaction {
        id: Uuid::new_v4(),
        from: from.clone(),
        to: to.clone(),
        amount,
        nonce,
        block_hash: None,
        signature,
        timestamp: Utc::now(),
        status: "pending".to_string(),
    };
    broadcast_transaction(&tx.id.to_string(), "pending");
    tx
}