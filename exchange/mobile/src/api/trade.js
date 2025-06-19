export async function getOrderBook(symbol) {
  const res = await fetch(`https://your.quantora.exchange/api/markets/${encodeURIComponent(symbol)}/orderbook`);
  if (!res.ok) throw new Error("Failed to fetch order book");
  return res.json();
}
export async function placeOrder(symbol, side, price, amount) {
  const res = await fetch(`https://your.quantora.exchange/api/orders`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ symbol, side, price, amount })
  });
  if (!res.ok) throw new Error("Order failed");
  return res.json();
}