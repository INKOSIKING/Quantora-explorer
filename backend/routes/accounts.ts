import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let accounts: Array<{ id: number; userId: number; type: string; balance: number; createdAt: string }> = [];

// GET all accounts
router.get("/", (req, res) => res.json(accounts));

// GET one account
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const account = accounts.find(a => a.id === Number(req.params.id));
  if (!account) return res.status(404).json({ error: "Account not found" });
  res.json(account);
});

// CREATE account
router.post("/",
  body("userId").isInt({ min: 1 }),
  body("type").isIn(["checking", "savings"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { userId, type } = req.body;
    if (accounts.some(a => a.userId === userId && a.type === type))
      return res.status(409).json({ error: "Account of this type already exists for user" });
    const account = {
      id: accounts.length + 1,
      userId,
      type,
      balance: 0,
      createdAt: new Date().toISOString(),
    };
    accounts.push(account);
    res.status(201).json(account);
  }
);

// UPDATE account (only type allowed to change)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("type").isIn(["checking", "savings"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = accounts.findIndex(a => a.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Account not found" });
    // Prevent duplicate type for user
    const { userId } = accounts[idx];
    if (accounts.some(a => a.userId === userId && a.type === req.body.type && a.id !== Number(req.params.id)))
      return res.status(409).json({ error: "Account of this type already exists for user" });
    accounts[idx].type = req.body.type;
    res.json(accounts[idx]);
  }
);

// DELETE account
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = accounts.findIndex(a => a.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Account not found" });
  accounts.splice(idx, 1);
  res.status(204).send();
});

export { router as accountsRouter };