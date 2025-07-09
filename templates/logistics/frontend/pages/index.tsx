import React, { useEffect, useState } from "react";
export default function Home() {
  const [shipments, setShipments] = useState([]);
  useEffect(() => {
    fetch("/api/shipments").then(r => r.json()).then(setShipments);
  }, []);
  return (
    <div>
      <h1>Logistics Dashboard</h1>
      <ul>
        {shipments.map((s: any) => <li key={s.id}>{s.status} - {s.createdAt}</li>)}
      </ul>
    </div>
  );
}