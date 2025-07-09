import React, { useEffect, useState } from "react";
import axios from "axios";

type Order = {
  price: string;
  amount: string;
};

export default function Orderbook() {
  const [bids, setBids] = useState<Order[]>([]);
  const [asks, setAsks] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios.get("/api/orderbook")
      .then(res => {
        setBids(res.data.bids);
        setAsks(res.data.asks);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  return (
    <div>
      <h1>Order Book</h1>
      {loading ? (
        <p>Loading...</p>
      ) : (
        <div style={{ display: "flex", justifyContent: "space-between" }}>
          <div>
            <h2>Bids</h2>
            <table>
              <thead>
                <tr>
                  <th>Price</th>
                  <th>Amount</th>
                </tr>
              </thead>
              <tbody>
                {bids.map((bid, idx) => (
                  <tr key={idx}>
                    <td>{bid.price}</td>
                    <td>{bid.amount}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div>
            <h2>Asks</h2>
            <table>
              <thead>
                <tr>
                  <th>Price</th>
                  <th>Amount</th>
                </tr>
              </thead>
              <tbody>
                {asks.map((ask, idx) => (
                  <tr key={idx}>
                    <td>{ask.price}</td>
                    <td>{ask.amount}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}