import { useState } from 'react';
import api from '../lib/api';

export default function Trade() {
  const [pair, setPair] = useState('BTC-USD');
  const [amount, setAmount] = useState('');
  const [price, setPrice] = useState('');
  const [side, setSide] = useState<'buy' | 'sell'>('buy');
  const [result, setResult] = useState(null);
  const [error, setError] = useState('');
  const [pending, setPending] = useState(false);

  const submit = async () => {
    setError('');
    setPending(true);
    try {
      const r = await api.post('/order', { pair, side, amount: Number(amount), price: Number(price) });
      setResult(r.data);
    } catch (e) {
      setError(e.response?.data?.message || 'Order failed');
      setResult(null);
    }
    setPending(false);
  };

  const disabled = !pair || !amount || !price || pending || isNaN(Number(amount)) || isNaN(Number(price));
  return (
    <div>
      <h2>Trade</h2>
      <input value={pair} onChange={e => setPair(e.target.value)} disabled={pending} />
      <input value={amount} onChange={e => setAmount(e.target.value)} placeholder="Amount" disabled={pending} />
      <input value={price} onChange={e => setPrice(e.target.value)} placeholder="Price" disabled={pending} />
      <select value={side} onChange={e => setSide(e.target.value as any)} disabled={pending}>
        <option value="buy">Buy</option>
        <option value="sell">Sell</option>
      </select>
      <button onClick={submit} disabled={disabled}>Submit</button>
      {pending && <p>Submitting...</p>}
      {error && <p style={{color:"red"}}>{error}</p>}
      {result && <pre>{JSON.stringify(result, null, 2)}</pre>}
    </div>
  );
}