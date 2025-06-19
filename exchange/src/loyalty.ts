import { db } from "./db";

export async function addPoints(userId: string, points: number) {
  await db.query(
    "INSERT INTO loyalty_points(user_id, points) VALUES ($1, $2) ON CONFLICT (user_id) DO UPDATE SET points = loyalty_points.points + $2",
    [userId, points]
  );
}

export async function getPoints(userId: string) {
  const r = await db.query("SELECT points FROM loyalty_points WHERE user_id=$1", [userId]);
  return r.rows[0]?.points || 0;
}