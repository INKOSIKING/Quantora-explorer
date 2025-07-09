import React, { useEffect, useState } from "react";
import { gqlQuery } from "../../api/quantora";

export default function ChainOverview() {
  const [blocks, setBlocks] = useState<any[]>([]);
  const [transactions, setTransactions] = useState<any[]>([]);
  const [proposals, setProposals] = useState<any[]>([]);
  const [validators, setValidators] = useState<any[]>([]);

  useEffect(() => {
    gqlQuery(`
      {
        blocks { height hash time txCount }
        transactions(limit: 10) { hash from to value }
        proposals { id title status }
        validators { address stake active }
      }
    `).then(data => {
      setBlocks(data.blocks || []);
      setTransactions(data.transactions || []);
      setProposals(data.proposals || []);
      setValidators(data.validators || []);
    });
  }, []);

  return (
    <div>
      <h3>Latest Blocks</h3>
      <table>
        <thead><tr><th>Height</th><th>Hash</th><th>Time</th><th>Txs</th></tr></thead>
        <tbody>
          {blocks.map(b => (
            <tr key={b.hash}>
              <td>{b.height}</td>
              <td>{b.hash.slice(0, 10)}...</td>
              <td>{new Date(b.time).toLocaleString()}</td>
              <td>{b.txCount}</td>
            </tr>
          ))}
        </tbody>
      </table>
      <h3>Latest Transactions</h3>
      <table>
        <thead><tr><th>Hash</th><th>From</th><th>To</th><th>Value</th></tr></thead>
        <tbody>
          {transactions.map(tx => (
            <tr key={tx.hash}>
              <td>{tx.hash.slice(0, 10)}...</td>
              <td>{tx.from}</td>
              <td>{tx.to}</td>
              <td>{tx.value}</td>
            </tr>
          ))}
        </tbody>
      </table>
      <h3>Governance Proposals</h3>
      <ul>
        {proposals.map(p => (
          <li key={p.id}>{p.title} <b>[{p.status}]</b></li>
        ))}
      </ul>
      <h3>Validators</h3>
      <table>
        <thead><tr><th>Address</th><th>Stake</th><th>Status</th></tr></thead>
        <tbody>
          {validators.map(v => (
            <tr key={v.address}>
              <td>{v.address.slice(0, 10)}...</td>
              <td>{v.stake}</td>
              <td>{v.active ? "Active" : "Inactive"}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}