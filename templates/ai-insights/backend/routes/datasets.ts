import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();
let datasets = [];
router.get("/", (req, res) => res.json(datasets));
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const ds = datasets.find(d => d.id === Number(req.params.id));
  if (!ds) return res.status(404).json({ error: "Dataset not found" });
  res.json(ds);
});
router.post("/", body("name").isString().isLength({ min: 2 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const { name } = req.body;
  const ds = { id: datasets.length + 1, name, uploadedAt: new Date().toISOString() };
  datasets.push(ds);
  res.status(201).json(ds);
});
// UPDATE/DELETE as above...
export { router as datasetsRouter };