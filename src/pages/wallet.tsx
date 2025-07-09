import React, { useEffect, useState } from "react";
import { fetchAssets, fetchBalance, fetchWalletAddr, stake } from "../api/quantora";

const USER = "alice"; // Replace with real auth/user context

export default function Wallet() {
  const [assets, setAssets] = useState<string[]>([]);
  const [balances, setBalances] = useState<Record<string, string>>({});
  const [addresses, setAddresses] = useState<Record<string, string | null>>({});
  const [stakeAmount, setStakeAmount] = useState("");

  useEffect(() => {
    fetchAssets().then((data) => setAssets(data.assets));
  }, []);

  useEffect(() => {
    assets.forEach((symbol) => {
      fetchBalance(USER, symbol).then((b) => setBalances((prev) => ({ ...prev, [symbol]: b.balance })));
      fetchWalletAddr(USER, symbol).then((a) => setAddresses((prev) => ({ ...prev, [symbol]: a.address })));
    });
  }, [assets]);

  return (
    <div>
      <h2>Wallet</h2>
      <table>
        <thead>
          <tr>
            <th>Asset</th>
            <th>Balance</th>
            <th>Wallet Address</th>
            <th>Stake</th>
          </tr>
        </thead>
        <tbody>
          {assets.map((symbol) => (
            <tr key={symbol}>
              <td>{symbol}</td>
              <td>{balances[symbol] || "0"}</td>
              <td style={{ fontSize: "0.8em" }}>{addresses[symbol]}</td>
              <td>
                <input
                  type="number"
                  placeholder="Amount"
                  value={stakeAmount}
                  onChange={(e) => setStakeAmount(e.target.value)}
                  style={{ width: "70px" }}
                />
                <button
                  onClick={() => {
                    stake(USER, symbol, stakeAmount).then(() => alert("Staked!"));
                  }}
                >
                  Stake
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {/* Add deposit, withdraw, transfer UI here */}
    </div>
  );
}