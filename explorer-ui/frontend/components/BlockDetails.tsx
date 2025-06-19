import React from "react";

type Props = {
  block: any;
};

export default function BlockDetails({ block }: Props) {
  if (!block) return <p>No block data.</p>;
  return (
    <div>
      <h3>Block #{block.height}</h3>
      <ul>
        <li>Hash: {block.hash}</li>
        <li>Timestamp: {block.timestamp}</li>
        <li>Tx count: {block.tx_count}</li>
        <li>Miner: {block.miner}</li>
      </ul>
      <h4>Transactions</h4>
      <ul>
        {Array.isArray(block.txs) && block.txs.length === 0 && <li>No transactions</li>}
        {Array.isArray(block.txs) &&
          block.txs.map((tx: any) => (
            <li key={tx.hash}>
              Hash: <a href={`/tx/${tx.hash}`}>{tx.hash}</a> | Amount: {tx.amount}
            </li>
          ))}
      </ul>
    </div>
  );
}