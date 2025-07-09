use crate::ws::WS_EVENT_BROADCASTER;
use crate::ws::WsEvent;
use tracing::warn;

pub fn broadcast_block_mined(hash: &str, height: u64) {
    let evt = WsEvent::BlockMined {
        hash: hash.to_owned(),
        height,
    };
    if WS_EVENT_BROADCASTER.send(evt).is_err() {
        warn!("No websocket listeners for block mined event");
    }
}

pub fn broadcast_transaction(tx_id: &str, status: &str) {
    let evt = WsEvent::Transaction {
        tx_id: tx_id.to_owned(),
        status: status.to_owned(),
    };
    let _ = WS_EVENT_BROADCASTER.send(evt);
}

pub fn broadcast_contract_event(contract: &str, log: &str) {
    let evt = WsEvent::ContractEvent {
        contract: contract.to_owned(),
        log: log.to_owned(),
    };
    let _ = WS_EVENT_BROADCASTER.send(evt);
}