import React, { useEffect, useState } from "react";
import { fetchAssets, fetchBalance } from "../api/quantora";
import { useUser } from "../components/Shared/UserContext";

export default function Dashboard() {
  const { user } = useUser();
  const [assets, setAssets] = useState<string[]>([]);
  const [balances, setBalances] = useState<Record<string, string>>({});
  const [totalUsd, setTotalUsd] = useState<number>(0);

  useEffect(() => {
    fetchAssets().then((data) => setAssets(data.assets));
  }, []);

  useEffect(() => {
    let isMounted = true;
    const getBalances = async () => {
      let total = 0;
      for (const symbol of assets) {
        const res = await fetchBalance(user, symbol);
        // Simulate price fetch, replace with real price API
        const price = symbol === "usdt" || symbol === "usd" ? 1 : 0.5;
        if (isMounted) {
          setBalances((prev) => ({ ...prev, [symbol]: res.balance }));
          total += parseFloat(res.balance) * price;
        }
      }
      if (isMounted) setTotalUsd(total);
    };
    if (assets.length) getBalances();
    return () => {
      isMounted = false;
    };
  }, [assets, user]);

  return (
    <div>
      <h2>Dashboard</h2>
      <div>
        <h4>Total Portfolio Value</h4>
        <div style={{ fontSize: "2em", color: "#4caf50" }}>${totalUsd.toFixed(2)} USD</div>
      </div>
      <div>
        <h4>Holdings</h4>
        <table>
          <thead>
            <tr>
              <th>Asset</th>
              <th>Balance</th>
            </tr>
          </thead>
          <tbody>
            {assets.map((symbol) => (
              <tr key={symbol}>
                <td>{symbol}</td>
                <td>{balances[symbol] || "0"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}