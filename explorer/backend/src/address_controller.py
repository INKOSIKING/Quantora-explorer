from fastapi import APIRouter, HTTPException
from db import get_address, analytics

router = APIRouter()

@router.get("/{address}")
def address_details(address: str):
    a = get_address(address)
    if not a:
        raise HTTPException(404, "Address not found")
    return a

@router.get("/{address}/analytics")
def address_analytics(address: str):
    data = analytics(address)
    if not data:
        raise HTTPException(404, "No analytics for address")
    return data