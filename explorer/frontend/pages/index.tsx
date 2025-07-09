import { useState } from 'react';
import api from '../lib/api';

export default function ExplorerHome() {
  const [q, setQ] = useState('');
  const [result, setResult] = useState(null);

  const search = async () => {
    setResult(await api.get(`/search?q=${encodeURIComponent(q)}`));
  };

  return (
    <div>
      <h1>Explorer</h1>
      <input value={q} onChange={e => setQ(e.target.value)} />
      <button onClick={search}>Search</button>
      {result && <pre>{JSON.stringify(result, null, 2)}</pre>}
    </div>
  );
}