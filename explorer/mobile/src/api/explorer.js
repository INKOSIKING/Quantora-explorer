const BASE_URL = "https://your.quantora.explorer/api";

export async function getBlockByHash(hash) {
  const res = await fetch(`${BASE_URL}/block/${hash}`);
  if (!res.ok) throw new Error("Block not found: " + await res.text());
  return await res.json();
}

export async function getTxByHash(hash) {
  const res = await fetch(`${BASE_URL}/tx/${hash}`);
  if (!res.ok) throw new Error("Tx not found: " + await res.text());
  return await res.json();
}

export async function getAddressInfo(address) {
  const res = await fetch(`${BASE_URL}/address/${address}`);
  if (!res.ok) throw new Error("Address not found: " + await res.text());
  return await res.json();
}