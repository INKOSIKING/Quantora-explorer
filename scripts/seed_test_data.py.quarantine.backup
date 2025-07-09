import psycopg2, random, string, time

conn = psycopg2.connect("dbname=quantora user=postgres")
cur = conn.cursor()

def randstr(n): return ''.join(random.choices(string.ascii_lowercase, k=n))

users = [f"user{i}" for i in range(10)]
tokens = ["BTC", "ETH", "USDT"]

# Balances
for u in users:
    for t in tokens:
        cur.execute("INSERT INTO user_balances (user_id, token, amount) VALUES (%s, %s, %s) ON CONFLICT DO NOTHING",
                    (u, t, random.uniform(0.1, 10)))

# Watchlists
for u in users:
    for _ in range(3):
        addr = "0x" + randstr(40)
        cur.execute("INSERT INTO watchlists (user_id, address) VALUES (%s, %s) ON CONFLICT DO NOTHING", (u, addr))

# Trades (historical)
now = int(time.time())
for t in tokens:
    for i in range(100):
        price = random.uniform(1000, 40000)
        volume = random.uniform(0.01, 5)
        ts = now - i * 3600
        cur.execute("INSERT INTO trades (token, price, volume, timestamp) VALUES (%s, %s, %s, to_timestamp(%s))", (t, price, volume, ts))

# Staking
for u in users:
    cur.execute("INSERT INTO staking (user_id, amount, since) VALUES (%s, %s, NOW() - INTERVAL '30 days') ON CONFLICT DO NOTHING", (u, random.uniform(1, 50)))

# Referrals
for i in range(len(users)-1):
    cur.execute("INSERT INTO referrals (referrer, referred) VALUES (%s, %s) ON CONFLICT DO NOTHING", (users[i], users[i+1]))

# Loyalty
for u in users:
    cur.execute("INSERT INTO loyalty_points (user_id, points) VALUES (%s, %s) ON CONFLICT DO NOTHING", (u, random.randint(100, 10000)))

conn.commit()
cur.close()
conn.close()