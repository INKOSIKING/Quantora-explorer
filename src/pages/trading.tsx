import React, { useEffect, useState } from "react";
import { fetchAssets } from "../api/quantora";
import { useUser } from "../components/Shared/UserContext";

type Order = {
  price: string;
  amount: string;
};

export default function TradingPage() {
  const { user } = useUser();
  const [assets, setAssets] = useState<string[]>([]);
  const [base, setBase] = useState("");
  const [quote, setQuote] = useState("");
  const [side, setSide] = useState<"buy" | "sell">("buy");
  const [price, setPrice] = useState("");
  const [amount, setAmount] = useState("");
  const [orderbook, setOrderbook] = useState<{ bids: Order[]; asks: Order[] }>({
    bids: [],
    asks: [],
  });
  const [tradeResult, setTradeResult] = useState("");

  useEffect(() => {
    fetchAssets().then((data) => setAssets(data.assets));
  }, []);

  useEffect(() => {
    if (base && quote) {
      // TODO: Fetch orderbook from Quantora backend
      setOrderbook({
        bids: [
          { price: "0.99", amount: "100" },
          { price: "0.98", amount: "50" },
        ],
        asks: [
          { price: "1.01", amount: "75" },
          { price: "1.02", amount: "30" },
        ],
      });
    }
  }, [base, quote]);

  function placeOrder() {
    // TODO: Call Quantora trading endpoint
    setTradeResult(
      `Order placed: ${side} ${amount} ${base}/${quote} at ${price}`
    );
  }

  return (
    <div>
      <h2>Trading</h2>
      <div>
        <select value={base} onChange={(e) => setBase(e.target.value)}>
          <option value="">Base</option>
          {assets.map((a) => (
            <option key={a} value={a}>
              {a}
            </option>
          ))}
        </select>
        <select value={quote} onChange={(e) => setQuote(e.target.value)}>
          <option value="">Quote</option>
          {assets.map((a) => (
            <option key={a} value={a}>
              {a}
            </option>
          ))}
        </select>
      </div>
      <div>
        <button onClick={() => setSide("buy")} style={{ background: side === "buy" ? "#4caf50" : "#eee" }}>
          Buy
        </button>
        <button onClick={() => setSide("sell")} style={{ background: side === "sell" ? "#f44336" : "#eee" }}>
          Sell
        </button>
      </div>
      <div>
        <input
          type="number"
          placeholder="Price"
          value={price}
          onChange={(e) => setPrice(e.target.value)}
        />
        <input
          type="number"
          placeholder="Amount"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
        />
        <button
          disabled={!base || !quote || !price || !amount}
          onClick={placeOrder}
        >
          Place Order
        </button>
      </div>
      {tradeResult && <div>{tradeResult}</div>}
      <div style={{ display: "flex", gap: "2em", marginTop: "2em" }}>
        <div>
          <h4>Orderbook - Bids</h4>
          <table>
            <thead>
              <tr>
                <th>Price</th>
                <th>Amount</th>
              </tr>
            </thead>
            <tbody>
              {orderbook.bids.map((o, i) => (
                <tr key={i}>
                  <td>{o.price}</td>
                  <td>{o.amount}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div>
          <h4>Orderbook - Asks</h4>
          <table>
            <thead>
              <tr>
                <th>Price</th>
                <th>Amount</th>
              </tr>
            </thead>
            <tbody>
              {orderbook.asks.map((o, i) => (
                <tr key={i}>
                  <td>{o.price}</td>
                  <td>{o.amount}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}