import React, { useEffect, useState } from "react";
import { fetchAssets, fetchBalance } from "../api/quantora";
import { useUser } from "../components/Shared/UserContext";

export default function BalancePage() {
  const { user } = useUser();
  const [assets, setAssets] = useState<string[]>([]);
  const [balances, setBalances] = useState<Record<string, string>>({});
  const [filter, setFilter] = useState("");

  useEffect(() => {
    fetchAssets().then((data) => setAssets(data.assets));
  }, []);

  useEffect(() => {
    let isMounted = true;
    const getBalances = async () => {
      for (const symbol of assets) {
        const res = await fetchBalance(user, symbol);
        if (isMounted) setBalances((prev) => ({ ...prev, [symbol]: res.balance }));
      }
    };
    if (assets.length) getBalances();
    return () => {
      isMounted = false;
    };
  }, [assets, user]);

  const filteredAssets = assets.filter((a) =>
    a.toLowerCase().includes(filter.toLowerCase())
  );

  return (
    <div>
      <h2>Balance</h2>
      <input
        type="text"
        placeholder="Filter asset"
        value={filter}
        onChange={(e) => setFilter(e.target.value)}
      />
      <table>
        <thead>
          <tr>
            <th>Asset</th>
            <th>Balance</th>
          </tr>
        </thead>
        <tbody>
          {filteredAssets.map((symbol) => (
            <tr key={symbol}>
              <td>{symbol}</td>
              <td>{balances[symbol] || "0"}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}