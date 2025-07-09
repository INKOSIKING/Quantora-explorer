import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let datasets: Array<{ id: number; name: string; description: string; createdAt: string }> = [];

// GET all datasets
router.get("/", (req, res) => res.json(datasets));

// GET one dataset
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const dataset = datasets.find(d => d.id === Number(req.params.id));
  if (!dataset) return res.status(404).json({ error: "Dataset not found" });
  res.json(dataset);
});

// CREATE dataset
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("description").optional().isString(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { name, description } = req.body;
    if (datasets.some(d => d.name === name))
      return res.status(409).json({ error: "Dataset name already exists" });
    const dataset = { id: datasets.length + 1, name, description, createdAt: new Date().toISOString() };
    datasets.push(dataset);
    res.status(201).json(dataset);
  }
);

// UPDATE dataset
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("name").optional().isString().isLength({ min: 2 }),
  body("description").optional().isString(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = datasets.findIndex(d => d.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Dataset not found" });
    // Prevent duplicate name
    if (req.body.name && datasets.some(d => d.name === req.body.name && d.id !== Number(req.params.id)))
      return res.status(409).json({ error: "Dataset name already exists" });
    datasets[idx] = { ...datasets[idx], ...req.body };
    res.json(datasets[idx]);
  }
);

// DELETE dataset
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = datasets.findIndex(d => d.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Dataset not found" });
  datasets.splice(idx, 1);
  res.status(204).send();
});

export { router as datasetsRouter };