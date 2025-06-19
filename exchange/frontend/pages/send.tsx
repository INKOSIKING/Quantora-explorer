import { useState } from "react";
import api from "../lib/api";

export default function SendCrypto() {
  const [to, setTo] = useState("");
  const [token, setToken] = useState("BTC");
  const [amount, setAmount] = useState("");
  const [result, setResult] = useState<any>(null);
  const send = async () => {
    setResult(await api.post("/wallet/send", { to, token, amount: Number(amount) }));
  };
  return (
    <div>
      <h2>Send Crypto</h2>
      <input
        value={to}
        onChange={(e) => setTo(e.target.value)}
        placeholder="Recipient User ID"
      />
      <select value={token} onChange={(e) => setToken(e.target.value)}>
        <option value="BTC">BTC</option>
        <option value="ETH">ETH</option>
      </select>
      <input
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        placeholder="Amount"
      />
      <button onClick={send}>Send</button>
      {result && <pre>{JSON.stringify(result, null, 2)}</pre>}
    </div>
  );
}