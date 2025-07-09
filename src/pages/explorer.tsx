import React, { useEffect, useState } from "react";
import { gqlQuery } from "../api/quantora";

export default function Explorer() {
  const [assets, setAssets] = useState<string[]>([]);
  useEffect(() => {
    gqlQuery(`{ assets }`).then((data) => setAssets(data.assets));
  }, []);

  return (
    <div>
      <h2>Chain Explorer</h2>
      <section>
        <h3>Supported Assets</h3>
        <ul>
          {assets.map((a) => (
            <li key={a}>{a}</li>
          ))}
        </ul>
      </section>
      {/* Add block/tx/proposal/validator tables here */}
    </div>
  );
}