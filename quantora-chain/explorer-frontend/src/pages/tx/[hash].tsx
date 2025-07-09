import React, { useEffect, useState } from "react";
import { useRouter } from "next/router";
import axios from "axios";

interface Tx {
  hash: string;
  from: string;
  to: string;
  value: string;
  blockHeight: number;
  timestamp: number;
}

export default function TxPage() {
  const router = useRouter();
  const { hash } = router.query;
  const [tx, setTx] = useState<Tx | null>(null);
  const [loading, setLoading] = useState<boolean>(true);

  useEffect(() => {
    if (!hash) return;
    axios.get(`/api/tx/${hash}`)
      .then(res => {
        setTx(res.data.tx);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, [hash]);

  if (loading) return <p>Loading...</p>;
  if (!tx) return <p>Transaction not found.</p>;

  return (
    <div>
      <h1>Transaction {tx.hash}</h1>
      <ul>
        <li><strong>From:</strong> {tx.from}</li>
        <li><strong>To:</strong> {tx.to}</li>
        <li><strong>Value:</strong> {tx.value}</li>
        <li><strong>Block Height:</strong> {tx.blockHeight}</li>
        <li><strong>Timestamp:</strong> {new Date(tx.timestamp * 1000).toLocaleString()}</li>
      </ul>
    </div>
  );
}