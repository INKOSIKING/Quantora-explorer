import requests, random, string

API = "https://exchange.yourdomain.com/api/v1"

def random_email():
    return "".join(random.choices(string.ascii_lowercase, k=8)) + "@testmail.com"

def test_kyc_flow():
    user = {"email": random_email(), "password": "TestPass123!"}
    r = requests.post(f"{API}/register", json=user)
    assert r.status_code == 200
    token = r.json()["token"]
    kyc = {"id_doc": "base64...", "face": "base64..."}
    r = requests.post(f"{API}/kyc", headers={"Authorization": f"Bearer {token}"}, json=kyc)
    assert r.status_code == 200

def test_deposit_withdraw():
    # Register & login
    user = {"email": random_email(), "password": "TestPass123!"}
    token = requests.post(f"{API}/register", json=user).json()["token"]
    # Deposit
    r = requests.post(f"{API}/deposit", headers={"Authorization": f"Bearer {token}"}, json={"asset":"BTC","amount":0.1})
    assert r.status_code == 200
    # Withdraw with fraud trigger
    r = requests.post(f"{API}/withdraw", headers={"Authorization": f"Bearer {token}"}, json={"asset":"BTC","amount":10000})
    assert r.status_code == 403 or "fraud" in r.text

def test_advanced_orders():
    token = requests.post(f"{API}/register", json={"email":random_email(),"password":"TestPass123!"}).json()["token"]
    for order_type in ["stop_loss", "trailing_stop", "iceberg"]:
        r = requests.post(f"{API}/order", headers={"Authorization":f"Bearer {token}"}, json={"type":order_type,"pair":"BTC-USD","size":0.1,"price":10000})
        assert r.status_code == 200

if __name__ == "__main__":
    test_kyc_flow()
    test_deposit_withdraw()
    test_advanced_orders()
    print("All exchange E2E tests passed.")