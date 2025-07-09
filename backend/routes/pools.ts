import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let pools: Array<{ id: number; name: string; tokenA: string; tokenB: string; totalLiquidity: number; createdAt: string }> = [];

// GET all pools
router.get("/", (req, res) => res.json(pools));

// GET single pool
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const pool = pools.find(p => p.id === Number(req.params.id));
  if (!pool) return res.status(404).json({ error: "Pool not found" });
  res.json(pool);
});

// CREATE pool (unique name)
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("tokenA").isString().isLength({ min: 2 }),
  body("tokenB").isString().isLength({ min: 2 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { name, tokenA, tokenB } = req.body;
    if (pools.some(p => p.name === name))
      return res.status(409).json({ error: "Pool name already exists" });
    const pool = { id: pools.length + 1, name, tokenA, tokenB, totalLiquidity: 0, createdAt: new Date().toISOString() };
    pools.push(pool);
    res.status(201).json(pool);
  }
);

// UPDATE pool (only tokenA/tokenB allowed)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("tokenA").optional().isString().isLength({ min: 2 }),
  body("tokenB").optional().isString().isLength({ min: 2 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = pools.findIndex(p => p.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Pool not found" });
    pools[idx] = { ...pools[idx], ...req.body };
    res.json(pools[idx]);
  }
);

// DELETE pool
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = pools.findIndex(p => p.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Pool not found" });
  pools.splice(idx, 1);
  res.status(204).send();
});

export { router as poolsRouter };