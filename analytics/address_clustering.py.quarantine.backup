import networkx as nx
import psycopg2

def build_address_graph():
    conn = psycopg2.connect("dbname=explorer user=postgres")
    cur = conn.cursor()
    cur.execute("SELECT from_address, to_address FROM transactions")
    edges = cur.fetchall()
    G = nx.Graph()
    G.add_edges_from(edges)
    return G

def cluster_addresses(G):
    # Simple approach: connected components as clusters
    clusters = list(nx.connected_components(G))
    return clusters

def main():
    G = build_address_graph()
    clusters = cluster_addresses(G)
    print(f"Found {len(clusters)} address clusters")
    # Save to DB or file
    with open("analytics/address_clusters.json", "w") as f:
        import json
        json.dump([list(c) for c in clusters], f)

if __name__ == "__main__":
    main()