import React, { useEffect, useState } from "react";

export function BlockView({ number }: { number: string }) {
  const [block, setBlock] = useState<any|null>(null);

  useEffect(() => {
    fetch(`/api/block/${number}`)
      .then(r => r.json())
      .then(data => setBlock(data));
  }, [number]);

  if (!block)
    return <div>Loading block...</div>;

  return (
    <div>
      <h2>Block #{block.number}</h2>
      <p>Hash: {block.hash}</p>
      <p>Parent: {block.parent_hash}</p>
      <p>Timestamp: {block.timestamp}</p>
      {/* Add more block details as needed */}
    </div>
  );
}