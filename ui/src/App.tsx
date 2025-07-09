import React, { useState } from "react";
import { BlockView } from "./components/BlockView";
import { TxView } from "./components/TxView";
import { AddressView } from "./components/AddressView";
import { StatsChart } from "./components/StatsChart";

export default function App() {
  const [search, setSearch] = useState("");
  const [type, setType] = useState<"block"|"tx"|"address"|"">("");

  function onSearch() {
    if (/^0x[a-fA-F0-9]{64}$/.test(search)) setType("tx");
    else if (/^\d+$/.test(search)) setType("block");
    else if (/^0x[a-fA-F0-9]{40}$/.test(search)) setType("address");
    else alert("Not recognized");
  }

  return (
    <div>
      <h1>Quantora Block Explorer</h1>
      <input value={search} onChange={e=>setSearch(e.target.value)} placeholder="Block #, Tx hash, Address"/>
      <button onClick={onSearch}>Search</button>
      {type==="block" && <BlockView number={search}/>}
      {type==="tx" && <TxView hash={search}/>}
      {type==="address" && <AddressView address={search}/>}
      <StatsChart />
    </div>
  );
}