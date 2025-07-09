import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let rewards: Array<{ id: number; stakeId: number; amount: number; issuedAt: string }> = [];

// GET all rewards
router.get("/", (req, res) => res.json(rewards));

// GET single reward
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const reward = rewards.find(r => r.id === Number(req.params.id));
  if (!reward) return res.status(404).json({ error: "Reward not found" });
  res.json(reward);
});

// CREATE reward (one per stake)
router.post("/",
  body("stakeId").isInt({ min: 1 }),
  body("amount").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { stakeId, amount } = req.body;
    if (rewards.some(r => r.stakeId === stakeId))
      return res.status(409).json({ error: "Reward already issued for this stake" });
    const reward = {
      id: rewards.length + 1,
      stakeId,
      amount,
      issuedAt: new Date().toISOString()
    };
    rewards.push(reward);
    res.status(201).json(reward);
  }
);

// UPDATE reward (amount only, not typical)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("amount").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = rewards.findIndex(r => r.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Reward not found" });
    rewards[idx].amount = req.body.amount;
    res.json(rewards[idx]);
  }
);

// DELETE reward
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = rewards.findIndex(r => r.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Reward not found" });
  rewards.splice(idx, 1);
  res.status(204).send();
});

export { router as rewardsRouter };