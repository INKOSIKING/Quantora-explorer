import time, json, requests
from datetime import datetime, timedelta

def check_suspicious_transactions():
    with open('compliance/txlog_index.json') as f:
        txs = json.load(f)
    for tx in txs:
        if tx["amount"] > 100000 or "sanctioned" in tx["counterparty"]:
            generate_alert(tx)

def generate_alert(tx):
    sar = {
        "user_id": tx["user_id"],
        "reason": "Large transfer or sanctioned counterparty",
        "tx_id": tx["tx_id"],
        "reported_at": datetime.utcnow().isoformat()
    }
    with open(f'compliance/sar_{tx["user_id"]}_{tx["tx_id"]}.json', 'w') as f:
        json.dump(sar, f, indent=2)
    requests.post("https://alerting.company.com/webhook", json=sar)

while True:
    check_suspicious_transactions()
    time.sleep(300)