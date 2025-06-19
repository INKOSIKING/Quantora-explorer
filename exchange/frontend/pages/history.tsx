import { useState, useEffect } from 'react';
import api from '../lib/api';

export default function History() {
  const [orders, setOrders] = useState([]);
  useEffect(() => {
    api.get('/order/history').then(r => setOrders(r.data));
  }, []);
  return (
    <div>
      <h2>Your Order History</h2>
      <table>
        <thead>
          <tr><th>Pair</th><th>Side</th><th>Amount</th><th>Price</th><th>Status</th></tr>
        </thead>
        <tbody>
          {orders.map(o =>
            <tr key={o.id}>
              <td>{o.pair}</td>
              <td>{o.side}</td>
              <td>{o.amount}</td>
              <td>{o.price}</td>
              <td>{o.status}</td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}