import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let swaps: Array<{ id: number; poolId: number; fromToken: string; toToken: string; amount: number; createdAt: string }> = [];

// GET all swaps
router.get("/", (req, res) => res.json(swaps));

// GET single swap
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const swap = swaps.find(s => s.id === Number(req.params.id));
  if (!swap) return res.status(404).json({ error: "Swap not found" });
  res.json(swap);
});

// CREATE swap (must reference existing pool)
router.post("/",
  body("poolId").isInt({ min: 1 }),
  body("fromToken").isString().isLength({ min: 2 }),
  body("toToken").isString().isLength({ min: 2 }),
  body("amount").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { poolId, fromToken, toToken, amount } = req.body;
    // In real app: check pool exists
    if (fromToken === toToken)
      return res.status(400).json({ error: "Cannot swap the same token" });
    const swap = {
      id: swaps.length + 1,
      poolId,
      fromToken,
      toToken,
      amount,
      createdAt: new Date().toISOString()
    };
    swaps.push(swap);
    res.status(201).json(swap);
  }
);

// UPDATE swap (not typical; allow amount)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("amount").optional().isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = swaps.findIndex(s => s.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Swap not found" });
    swaps[idx] = { ...swaps[idx], ...req.body };
    res.json(swaps[idx]);
  }
);

// DELETE swap
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = swaps.findIndex(s => s.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Swap not found" });
  swaps.splice(idx, 1);
  res.status(204).send();
});

export { router as swapsRouter };