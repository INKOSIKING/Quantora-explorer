import React, { useEffect, useState } from "react";
export default function Products() {
  const [products, setProducts] = useState([]);
  useEffect(() => {
    fetch("/api/products").then(r => r.json()).then(setProducts);
  }, []);
  return (
    <div>
      <h2>Products</h2>
      <ul>
        {products.map((p: any) => (
          <li key={p.id}>{p.name} - ${p.price} (Stock: {p.stock})</li>
        ))}
      </ul>
    </div>
  );
}