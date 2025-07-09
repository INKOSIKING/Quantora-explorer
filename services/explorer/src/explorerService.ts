export async function getBlock(number: number) {
  // Query from indexed DB or chain RPC
  return { number, hash: "0xabc...", txCount: 42, timestamp: "2025-06-13T18:00:00Z" };
}

export async function getTx(hash: string) {
  // Query from indexed DB or chain RPC
  return { hash, status: "success", from: "0x...", to: "0x...", value: "1000 QTX" };
}

export async function getAccount(address: string) {
  // Query from indexed DB or chain RPC
  return { address, balance: "100000 QTX", txCount: 10 };
}