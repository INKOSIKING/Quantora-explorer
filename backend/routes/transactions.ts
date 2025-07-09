import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let transactions: Array<{ id: number; fromAccountId: number; toAccountId: number; amount: number; createdAt: string }> = [];
let accounts: Array<{ id: number; userId: number; type: string; balance: number; createdAt: string }> = []; // Must be shared with accountsRouter in real app

// GET all transactions
router.get("/", (req, res) => res.json(transactions));

// GET one transaction
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const tx = transactions.find(t => t.id === Number(req.params.id));
  if (!tx) return res.status(404).json({ error: "Transaction not found" });
  res.json(tx);
});

// CREATE transaction with business rules
router.post("/",
  body("fromAccountId").isInt({ min: 1 }),
  body("toAccountId").isInt({ min: 1 }),
  body("amount").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { fromAccountId, toAccountId, amount } = req.body;
    if (fromAccountId === toAccountId)
      return res.status(400).json({ error: "Cannot transfer to the same account" });

    const fromAcc = accounts.find(a => a.id === fromAccountId);
    const toAcc = accounts.find(a => a.id === toAccountId);
    if (!fromAcc || !toAcc)
      return res.status(404).json({ error: "Account not found" });
    if (fromAcc.balance < amount)
      return res.status(400).json({ error: "Insufficient funds" });

    fromAcc.balance -= amount;
    toAcc.balance += amount;

    const tx = { id: transactions.length + 1, fromAccountId, toAccountId, amount, createdAt: new Date().toISOString() };
    transactions.push(tx);
    res.status(201).json(tx);
  }
);

// DELETE transaction (rare, but for demo)
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = transactions.findIndex(t => t.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Transaction not found" });
  transactions.splice(idx, 1);
  res.status(204).send();
});

export { router as transactionsRouter };