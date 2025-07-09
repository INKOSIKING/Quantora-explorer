import React, { useEffect, useState } from "react";
import { List, Input, Button } from "antd";
import api from "../api";

export const Watchlist = () => {
  const [addresses, setAddresses] = useState([]);
  const [input, setInput] = useState("");
  useEffect(() => {
    api.get("/analytics/watchlist").then(r => setAddresses(r.data));
  }, []);
  const add = () => {
    api.post("/analytics/watchlist", { address: input }).then(() => setAddresses([...addresses, input]));
    setInput("");
  };
  return (
    <>
      <Input value={input} onChange={e => setInput(e.target.value)} placeholder="Address" />
      <Button onClick={add}>Add</Button>
      <List dataSource={addresses} renderItem={item => <List.Item>{item}</List.Item>} />
    </>
  );
};