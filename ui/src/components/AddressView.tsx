import React, { useEffect, useState } from "react";

export function AddressView({ address }: { address: string }) {
  const [txs, setTxs] = useState<any[]>([]);
  const [page, setPage] = useState(1);
  const [total, setTotal] = useState(0);

  useEffect(() => {
    fetch(`/api/address/${address}/txs?page=${page}`)
      .then(r => r.json())
      .then(data => {
        setTxs(data);
        setTotal(data.length);
      });
  }, [address, page]);

  return (
    <div>
      <h2>Transactions for {address}</h2>
      <ul>
        {txs.map(tx => (
          <li key={tx.hash}>
            <span>{tx.hash}</span> (block: {tx.block_number}, value: {tx.value})
          </li>
        ))}
      </ul>
      <button disabled={page<=1} onClick={()=>setPage(page-1)}>Prev</button>
      <button disabled={txs.length===0} onClick={()=>setPage(page+1)}>Next</button>
    </div>
  );
}