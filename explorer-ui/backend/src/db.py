import psycopg2
from psycopg2.extras import RealDictCursor

def get_conn():
    return psycopg2.connect("dbname=quantora user=postgres")

def get_block(block_hash):
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute("SELECT * FROM blocks WHERE hash = %s", (block_hash,))
        return cur.fetchone()

def get_tx(tx_hash):
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute("SELECT * FROM transactions WHERE hash = %s", (tx_hash,))
        return cur.fetchone()

def get_address(address):
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute("SELECT * FROM addresses WHERE address = %s", (address,))
        return cur.fetchone()

def search_blocks(q):
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute("SELECT * FROM blocks WHERE hash ILIKE %s LIMIT 20", (f"%{q}%",))
        return cur.fetchall()

def analytics(address):
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute("""
            SELECT COUNT(*) as tx_count, SUM(value) as total_value
            FROM transactions WHERE from_address = %s OR to_address = %s
        """, (address, address))
        return cur.fetchone()