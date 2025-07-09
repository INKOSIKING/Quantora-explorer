import React, { useState } from "react";
import axios from "axios";

export default function WalletPage() {
  const [address, setAddress] = useState("");
  const [balance, setBalance] = useState<string | null>(null);

  const fetchBalance = async () => {
    if (!address) return;
    const res = await axios.get(`/api/wallet/${address}/balance`);
    setBalance(res.data.balance);
  };

  return (
    <div>
      <h1>Wallet</h1>
      <input
        type="text"
        placeholder="Enter wallet address"
        value={address}
        onChange={e => setAddress(e.target.value)}
      />
      <button onClick={fetchBalance} disabled={!address}>
        Check Balance
      </button>
      {balance !== null && (
        <div>
          <strong>Balance:</strong> {balance}
        </div>
      )}
    </div>
  );
}