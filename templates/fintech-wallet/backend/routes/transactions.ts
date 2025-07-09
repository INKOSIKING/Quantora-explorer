import { Router } from "express";
const router = Router();
let transactions = [];
router.post("/", (req, res) => {
  const tx = { ...req.body, id: transactions.length + 1, createdAt: new Date().toISOString() };
  transactions.push(tx);
  res.status(201).json(tx);
});
router.get("/", (req, res) => res.json(transactions));
export { router as transactionsRouter };