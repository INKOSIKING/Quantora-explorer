import React, { useEffect, useState } from "react";
import { fetchAssets, swap } from "../api/quantora";

const USER = "alice"; // Replace with real user

export default function Exchange() {
  const [assets, setAssets] = useState<string[]>([]);
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const [amount, setAmount] = useState("");
  const [received, setReceived] = useState("");

  useEffect(() => {
    fetchAssets().then((data) => setAssets(data.assets));
  }, []);

  const doSwap = async () => {
    if (from && to && amount) {
      const result = await swap(USER, from, to, amount);
      setReceived(result.received);
    }
  };

  return (
    <div>
      <h2>Exchange</h2>
      <select value={from} onChange={(e) => setFrom(e.target.value)}>
        <option value="">From</option>
        {assets.map((a) => (
          <option key={a} value={a}>{a}</option>
        ))}
      </select>
      <select value={to} onChange={(e) => setTo(e.target.value)}>
        <option value="">To</option>
        {assets.map((a) => (
          <option key={a} value={a}>{a}</option>
        ))}
      </select>
      <input
        type="number"
        placeholder="Amount"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        style={{ width: "100px" }}
      />
      <button onClick={doSwap}>Swap</button>
      {received && <div>Received: {received}</div>}
    </div>
  );
}