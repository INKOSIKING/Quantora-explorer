import express from "express";
import { listItem, buyItem, getItems } from "./service";

const app = express();
app.use(express.json());

app.post("/list", async (req, res) => {
  const { seller, item, price } = req.body;
  const result = await listItem(seller, item, price);
  res.json(result);
});

app.post("/buy", async (req, res) => {
  const { buyer, itemId } = req.body;
  const tx = await buyItem(buyer, itemId);
  res.json(tx);
});

app.get("/items", async (req, res) => {
  const items = await getItems();
  res.json(items);
});

app.listen(4700, () => console.log("Marketplace Service running on :4700"));