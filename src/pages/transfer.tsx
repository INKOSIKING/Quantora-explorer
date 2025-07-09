import React, { useEffect, useState } from "react";
import { fetchAssets } from "../api/quantora";
import { useUser } from "../components/Shared/UserContext";

export default function TransferPage() {
  const { user } = useUser();
  const [assets, setAssets] = useState<string[]>([]);
  const [selectedAsset, setSelectedAsset] = useState("");
  const [recipient, setRecipient] = useState("");
  const [amount, setAmount] = useState("");
  const [result, setResult] = useState("");

  useEffect(() => {
    fetchAssets().then((data) => setAssets(data.assets));
  }, []);

  function handleTransfer() {
    // Call Quantora transfer/send endpoint (not shown here)
    setResult(`Transfer of ${amount} ${selectedAsset} to ${recipient} submitted!`);
  }

  return (
    <div>
      <h2>Transfer</h2>
      <select value={selectedAsset} onChange={(e) => setSelectedAsset(e.target.value)}>
        <option value="">Select asset</option>
        {assets.map((a) => (
          <option key={a} value={a}>
            {a}
          </option>
        ))}
      </select>
      <input
        placeholder="Recipient address"
        value={recipient}
        onChange={(e) => setRecipient(e.target.value)}
      />
      <input
        type="number"
        placeholder="Amount"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
      />
      <button disabled={!selectedAsset || !recipient || !amount} onClick={handleTransfer}>
        Send
      </button>
      {result && <div>{result}</div>}
    </div>
  );
}