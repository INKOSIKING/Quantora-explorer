import express from "express";
import { body, validationResult } from "express-validator";
import { createWallet, getBalance, sendTx } from "./walletService";

const app = express();
app.use(express.json());

app.post("/wallet", async (req, res) => {
  const { userId, type } = req.body;
  const wallet = await createWallet(userId, type);
  res.json(wallet);
});

app.get("/wallet/:address/balance", async (req, res) => {
  const { address } = req.params;
  const balance = await getBalance(address);
  res.json({ balance });
});

app.post("/wallet/:address/send", [
  body("to").isString(),
  body("amount").isNumeric()
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

  const { address } = req.params;
  const { to, amount } = req.body;
  const tx = await sendTx(address, to, amount);
  res.json(tx);
});

app.listen(4100, () => console.log("QVault/QX Wallet API running on :4100"));