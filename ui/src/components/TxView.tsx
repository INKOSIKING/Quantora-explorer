import React, { useEffect, useState } from "react";

export function TxView({ hash }: { hash: string }) {
  const [tx, setTx] = useState<any|null>(null);

  useEffect(() => {
    fetch(`/api/tx/${hash}`)
      .then(r => r.json())
      .then(data => setTx(data));
  }, [hash]);

  if (!tx)
    return <div>Loading transaction...</div>;

  return (
    <div>
      <h2>Transaction {tx.hash}</h2>
      <p>Block: {tx.block_number}</p>
      <p>From: {tx.from_addr}</p>
      <p>To: {tx.to_addr}</p>
      <p>Value: {tx.value}</p>
      <p>Timestamp: {tx.timestamp}</p>
      {/* Add more transaction details as needed */}
    </div>
  );
}