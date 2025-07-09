// Quantora API integration (REST + GraphQL)
import axios from "axios";

const API_BASE = "http://localhost:8080";
const GQL_BASE = "http://localhost:8081/graphql";

export async function swap(user: string, from: string, to: string, amount: string) {
  const res = await axios.post(`${API_BASE}/swap`, { user, from, to, amount });
  return res.data as { received: string };
}

export async function stake(user: string, symbol: string, amount: string) {
  const res = await axios.post(`${API_BASE}/stake`, { user, symbol, amount });
  return res.data as { success: boolean };
}

export async function fetchBalance(user: string, symbol: string) {
  const res = await axios.post(`${API_BASE}/balance`, { user, symbol });
  return res.data as { balance: string };
}

export async function fetchWalletAddr(user: string, symbol: string) {
  const res = await axios.post(`${API_BASE}/wallet_addr`, { user, symbol });
  return res.data as { address: string | null };
}

export async function fetchAssets() {
  const res = await axios.get(`${API_BASE}/assets`);
  return res.data as { assets: string[] };
}

// Simple GQL query
export async function gqlQuery(query: string, variables = {}) {
  const res = await axios.post(GQL_BASE, { query, variables });
  return res.data.data;
}