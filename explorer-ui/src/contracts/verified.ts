import { db } from "../db";

export async function setVerified(address: string, verified: boolean) {
  await db.query(
    "UPDATE contracts SET verified=$2 WHERE address=$1",
    [address, verified]
  );
}

export async function isVerified(address: string) {
  const r = await db.query("SELECT verified FROM contracts WHERE address=$1", [address]);
  return r.rows[0]?.verified || false;
}