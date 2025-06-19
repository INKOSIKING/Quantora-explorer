# Quantora Explorer Backend

## Endpoints

- `/block/{block_hash}` — Get block details
- `/tx/{tx_hash}` — Get transaction details
- `/address/{address}` — Get address details
- `/address/{address}/analytics` — Get analytics for address
- `/search?q=...` — Search blocks

## Local Development

- Setup PostgreSQL and fill `.env`
- `pip install -r requirements.txt`
- `uvicorn src.app:app --reload --port 8003`
- Run tests: `pytest`

## Production

- Use HTTPS, production DB, proper error handling, and monitoring