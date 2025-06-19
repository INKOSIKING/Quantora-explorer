from fastapi import FastAPI, HTTPException, Request
import time
from db import get_block, get_tx, get_address, search_blocks, analytics

app = FastAPI()
search_counts = {}

@app.middleware("http")
async def rate_limit(request: Request, call_next):
    ip = request.client.host
    now = int(time.time())
    window = f"{ip}:{now // 60}"
    count = search_counts.get(window, 0)
    if count > 50:
        raise HTTPException(429, "Too many requests, slow down")
    search_counts[window] = count + 1
    return await call_next(request)

@app.get("/block/{block_hash}")
def block(block_hash: str):
    b = get_block(block_hash)
    if not b:
        raise HTTPException(404, "Block not found")
    return b

@app.get("/tx/{tx_hash}")
def tx(tx_hash: str):
    t = get_tx(tx_hash)
    if not t:
        raise HTTPException(404, "Transaction not found")
    return t

@app.get("/address/{address}")
def address(address: str):
    a = get_address(address)
    if not a:
        raise HTTPException(404, "Address not found")
    return a

@app.get("/search")
def search(q: str):
    if not q or len(q) < 3:
        raise HTTPException(400, "Query too short")
    results = search_blocks(q)
    if not results:
        return {"results": [], "message": "No match"}
    return {"results": results}

@app.get("/analytics/{address}")
def addr_analytics(address: str):
    data = analytics(address)
    if not data:
        raise HTTPException(404, "No analytics for address")
    return data