import httpx

class QuantoraRestClient:
    def __init__(self, base_url, api_key=None):
        self.base_url = base_url
        self.client = httpx.AsyncClient(base_url=base_url, headers={"Authorization": f"Bearer {api_key}"} if api_key else None, timeout=10)

    async def get_assets(self):
        r = await self.client.get("/assets")
        r.raise_for_status()
        return r.json()

    async def get_balance(self, user, symbol):
        r = await self.client.post("/balance", json={"user": user, "symbol": symbol})
        r.raise_for_status()
        return r.json()

    async def swap(self, user, from_, to, amount):
        r = await self.client.post("/swap", json={"user": user, "from": from_, "to": to, "amount": amount})
        r.raise_for_status()
        return r.json()
    # ...Full API surface