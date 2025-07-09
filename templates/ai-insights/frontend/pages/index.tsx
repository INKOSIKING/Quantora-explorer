import React, { useState } from "react";
export default function Home() {
  const [data, setData] = useState([10, 12, 18, 30, 5, 40]);
  const [insights, setInsights] = useState<any>(null);
  async function analyze() {
    const res = await fetch("/api/analytics/insights", {
      method: "POST",
      body: JSON.stringify({ dataset: data }),
      headers: { "Content-Type": "application/json" }
    });
    setInsights(await res.json());
  }
  return (
    <div>
      <h1>AI Insights Dashboard</h1>
      <textarea value={data.join(",")} onChange={e => setData(e.target.value.split(",").map(Number))} />
      <button onClick={analyze}>Analyze Data</button>
      {insights && <pre>{JSON.stringify(insights, null, 2)}</pre>}
    </div>
  );
}