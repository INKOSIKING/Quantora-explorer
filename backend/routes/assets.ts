import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let assets: Array<{ id: number; name: string; type: string; status: string }> = [];

// GET all assets
router.get("/", (req, res) => res.json(assets));

// GET single asset
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const asset = assets.find(a => a.id === Number(req.params.id));
  if (!asset) return res.status(404).json({ error: "Asset not found" });
  res.json(asset);
});

// CREATE asset
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("type").isString().isLength({ min: 2 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { name, type } = req.body;
    if (assets.some(a => a.name === name && a.type === type))
      return res.status(409).json({ error: "Asset with same name and type already exists" });
    const asset = { id: assets.length + 1, name, type, status: "active" };
    assets.push(asset);
    res.status(201).json(asset);
  }
);

// UPDATE asset status or name/type
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("name").optional().isString().isLength({ min: 2 }),
  body("type").optional().isString().isLength({ min: 2 }),
  body("status").optional().isIn(["active", "maintenance", "retired"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = assets.findIndex(a => a.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Asset not found" });
    // Prevent duplicate name+type
    if (
      (req.body.name || req.body.type) &&
      assets.some(
        a =>
          a.id !== Number(req.params.id) &&
          (req.body.name ? a.name === req.body.name : true) &&
          (req.body.type ? a.type === req.body.type : true)
      )
    )
      return res.status(409).json({ error: "Asset with same name and type already exists" });
    assets[idx] = { ...assets[idx], ...req.body };
    res.json(assets[idx]);
  }
);

// DELETE asset
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = assets.findIndex(a => a.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Asset not found" });
  assets.splice(idx, 1);
  res.status(204).send();
});

export { router as assetsRouter };