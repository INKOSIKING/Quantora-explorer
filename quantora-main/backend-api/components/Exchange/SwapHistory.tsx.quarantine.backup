import React, { useEffect, useState } from "react";
import { gqlQuery } from "../../api/quantora";

export default function SwapHistory({ user }: { user: string }) {
  const [history, setHistory] = useState<any[]>([]);
  useEffect(() => {
    gqlQuery(`
      { swapHistory(user: "${user}") { from to amount received at } }
    `).then(data => setHistory(data.swapHistory));
  }, [user]);

  return (
    <div>
      <h4>Recent Swaps</h4>
      <table>
        <thead><tr><th>From</th><th>To</th><th>Sent</th><th>Received</th><th>Time</th></tr></thead>
        <tbody>
          {history.map((s, i) => (
            <tr key={i}>
              <td>{s.from}</td>
              <td>{s.to}</td>
              <td>{s.amount}</td>
              <td>{s.received}</td>
              <td>{new Date(s.at).toLocaleString()}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}