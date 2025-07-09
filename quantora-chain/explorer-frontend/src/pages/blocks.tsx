import React, { useEffect, useState } from "react";
import axios from "axios";

interface Block {
  height: number;
  hash: string;
  prev_hash: string;
  timestamp: number;
  txs: string[];
  nonce: number;
}

export default function BlocksPage() {
  const [blocks, setBlocks] = useState<Block[]>([]);
  const [loading, setLoading] = useState<boolean>(true);

  useEffect(() => {
    axios.get("/api/blocks?limit=50")
      .then(res => {
        setBlocks(res.data.blocks);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  return (
    <div>
      <h1>Recent Blocks</h1>
      {loading ? (
        <p>Loading...</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Height</th>
              <th>Hash</th>
              <th>Previous Hash</th>
              <th>Timestamp</th>
              <th>Tx Count</th>
              <th>Nonce</th>
            </tr>
          </thead>
          <tbody>
            {blocks.map(block => (
              <tr key={block.hash}>
                <td>{block.height}</td>
                <td>{block.hash.substring(0, 12)}...</td>
                <td>{block.prev_hash.substring(0, 12)}...</td>
                <td>{new Date(block.timestamp * 1000).toLocaleString()}</td>
                <td>{block.txs.length}</td>
                <td>{block.nonce}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}