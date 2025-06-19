import { useState, useEffect } from "react";
import api from "../lib/api";

export default function Wallet() {
  const [balances, setBalances] = useState<{ token: string; amount: number }[]>([]);
  useEffect(() => {
    api.get("/user/wallet").then((r) => setBalances(r.data.balances || []));
  }, []);
  return (
    <div>
      <h2>Your Balances</h2>
      <table>
        <thead>
          <tr>
            <th>Token</th>
            <th>Amount</th>
          </tr>
        </thead>
        <tbody>
          {Object.entries(balances).map(([token, amount]) => (
            <tr key={token}>
              <td>{token}</td>
              <td>{amount as any}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}