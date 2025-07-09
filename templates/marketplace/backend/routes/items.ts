import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();
let items = [];
router.get("/", (req, res) => res.json(items));
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const item = items.find(x => x.id === Number(req.params.id));
  if (!item) return res.status(404).json({ error: "Item not found" });
  res.json(item);
});
router.post("/", body("name").isString().isLength({ min: 2 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const { name } = req.body;
  const item = { id: items.length + 1, name, createdAt: new Date().toISOString() };
  items.push(item);
  res.status(201).json(item);
});
// UPDATE/DELETE as above...
export { router as itemsRouter };