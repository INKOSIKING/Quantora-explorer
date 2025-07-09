import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();
let pools = [];
router.get("/", (req, res) => res.json(pools));
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const p = pools.find(x => x.id === Number(req.params.id));
  if (!p) return res.status(404).json({ error: "Pool not found" });
  res.json(p);
});
router.post("/", body("tokenA").isString(), body("tokenB").isString(), body("liquidity").isFloat({ gt: 0 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const { tokenA, tokenB, liquidity } = req.body;
  const p = { id: pools.length + 1, tokenA, tokenB, liquidity, createdAt: new Date().toISOString() };
  pools.push(p);
  res.status(201).json(p);
});
// UPDATE/DELETE as above...
export { router as poolsRouter };