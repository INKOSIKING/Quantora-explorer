import React, { useEffect, useState } from "react";
import { fetchAssets, fetchWalletAddr } from "../api/quantora";
import { useUser } from "../components/Shared/UserContext";

export default function WithdrawalPage() {
  const { user } = useUser();
  const [assets, setAssets] = useState<string[]>([]);
  const [selectedAsset, setSelectedAsset] = useState("");
  const [address, setAddress] = useState("");
  const [amount, setAmount] = useState("");
  const [withdrawAddr, setWithdrawAddr] = useState<string | null>(null);
  const [result, setResult] = useState("");

  useEffect(() => {
    fetchAssets().then((data) => setAssets(data.assets));
  }, []);

  useEffect(() => {
    if (selectedAsset)
      fetchWalletAddr(user, selectedAsset).then((addr) => setWithdrawAddr(addr.address));
  }, [selectedAsset, user]);

  function handleWithdraw() {
    // TODO: Call Quantora withdrawal endpoint
    setResult(`Withdrawal request for ${amount} ${selectedAsset} to ${address} submitted!`);
  }

  return (
    <div>
      <h2>Withdraw</h2>
      <select value={selectedAsset} onChange={(e) => setSelectedAsset(e.target.value)}>
        <option value="">Select asset</option>
        {assets.map((a) => (
          <option key={a} value={a}>
            {a}
          </option>
        ))}
      </select>
      <input
        placeholder="Destination Address"
        value={address}
        onChange={(e) => setAddress(e.target.value)}
      />
      <input
        type="number"
        placeholder="Amount"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
      />
      <button disabled={!selectedAsset || !address || !amount} onClick={handleWithdraw}>
        Withdraw
      </button>
      {withdrawAddr && (
        <div style={{ fontSize: "0.85em", color: "#444" }}>
          Your {selectedAsset} Quantora address: {withdrawAddr}
        </div>
      )}
      {result && <div>{result}</div>}
    </div>
  );
}