import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let stakes: Array<{ id: number; poolId: number; userId: number; amount: number; createdAt: string }> = [];

// GET all stakes
router.get("/", (req, res) => res.json(stakes));

// GET single stake
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const stake = stakes.find(s => s.id === Number(req.params.id));
  if (!stake) return res.status(404).json({ error: "Stake not found" });
  res.json(stake);
});

// CREATE stake (must reference existing pool)
router.post("/",
  body("poolId").isInt({ min: 1 }),
  body("userId").isInt({ min: 1 }),
  body("amount").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { poolId, userId, amount } = req.body;
    // In real app: check pool exists, user exists
    if (stakes.some(s => s.userId === userId && s.poolId === poolId))
      return res.status(409).json({ error: "User already staked in this pool" });
    const stake = {
      id: stakes.length + 1,
      poolId,
      userId,
      amount,
      createdAt: new Date().toISOString()
    };
    stakes.push(stake);
    res.status(201).json(stake);
  }
);

// UPDATE stake (amount only)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("amount").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = stakes.findIndex(s => s.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Stake not found" });
    stakes[idx].amount = req.body.amount;
    res.json(stakes[idx]);
  }
);

// DELETE stake
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = stakes.findIndex(s => s.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Stake not found" });
  stakes.splice(idx, 1);
  res.status(204).send();
});

export { router as stakesRouter };