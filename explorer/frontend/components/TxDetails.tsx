import React from "react";

type Props = {
  tx: any;
};

export default function TxDetails({ tx }: Props) {
  if (!tx) return <p>No transaction data.</p>;
  return (
    <div>
      <h3>Transaction</h3>
      <ul>
        <li>Hash: {tx.hash}</li>
        <li>From: <a href={`/address/${tx.from_address}`}>{tx.from_address}</a></li>
        <li>To: <a href={`/address/${tx.to_address}`}>{tx.to_address}</a></li>
        <li>Amount: {tx.amount}</li>
        <li>Block: <a href={`/block/${tx.block_hash}`}>{tx.block_hash}</a></li>
        <li>Status: {tx.status}</li>
        <li>Timestamp: {tx.timestamp}</li>
      </ul>
    </div>
  );
}