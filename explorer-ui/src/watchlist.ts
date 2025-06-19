import { db } from "./db";

export async function getUserWatchlist(userId: string) {
  return db.query("SELECT address FROM watchlists WHERE user_id=$1", [userId]);
}

export async function addToWatchlist(userId: string, address: string) {
  await db.query("INSERT INTO watchlists(user_id, address) VALUES ($1, $2) ON CONFLICT DO NOTHING", [userId, address]);
}