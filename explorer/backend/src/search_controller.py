from fastapi import APIRouter, HTTPException
from db import search_blocks

router = APIRouter()

@router.get("/")
def search(q: str):
    if not q or len(q) < 3:
        raise HTTPException(400, "Query too short")
    results = search_blocks(q)
    if not results:
        return {"results": [], "message": "No match"}
    return {"results": results}