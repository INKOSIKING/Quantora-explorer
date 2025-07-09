import express from "express";
import { getBlock, getTx, getAccount } from "./explorerService";

const app = express();

app.get("/block/:number", async (req, res) => {
  const block = await getBlock(Number(req.params.number));
  res.json(block);
});
app.get("/tx/:hash", async (req, res) => {
  const tx = await getTx(req.params.hash);
  res.json(tx);
});
app.get("/account/:address", async (req, res) => {
  const account = await getAccount(req.params.address);
  res.json(account);
});

app.listen(8000, () => console.log("Explorer API running on :8000"));