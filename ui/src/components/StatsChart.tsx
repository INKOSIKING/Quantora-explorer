import React, { useEffect, useState } from "react";

export function StatsChart() {
  const [stats, setStats] = useState<any[]>([]);
  const [days, setDays] = useState(30);

  useEffect(() => {
    fetch(`/api/stats/daily?days=${days}`)
      .then(r => r.json())
      .then(data => setStats(data));
  }, [days]);

  if (stats.length === 0)
    return <div>Loading stats...</div>;

  return (
    <div>
      <h2>Historical Stats (Last {days} days)</h2>
      <label>
        Days: <input type="number" value={days} min={1} max={365} onChange={e => setDays(Number(e.target.value))} />
      </label>
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>Blocks</th>
            <th>Txs</th>
            <th>Avg Block Time (s)</th>
          </tr>
        </thead>
        <tbody>
          {stats.map(row => (
            <tr key={row.day}>
              <td>{row.day}</td>
              <td>{row.blocks}</td>
              <td>{row.txs}</td>
              <td>{row.avg_block_time.toFixed(2)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}