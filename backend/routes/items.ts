import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let items: Array<{ id: number; sellerId: number; title: string; description: string; price: number; status: string; createdAt: string }> = [];

// GET all items
router.get("/", (req, res) => res.json(items));

// GET single item
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const item = items.find(i => i.id === Number(req.params.id));
  if (!item) return res.status(404).json({ error: "Item not found" });
  res.json(item);
});

// CREATE item
router.post("/",
  body("sellerId").isInt({ min: 1 }),
  body("title").isString().isLength({ min: 2 }),
  body("description").optional().isString(),
  body("price").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { sellerId, title, description, price } = req.body;
    const item = {
      id: items.length + 1,
      sellerId, title, description, price,
      status: "active",
      createdAt: new Date().toISOString()
    };
    items.push(item);
    res.status(201).json(item);
  }
);

// UPDATE item (title, description, price, status)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("title").optional().isString().isLength({ min: 2 }),
  body("description").optional().isString(),
  body("price").optional().isFloat({ gt: 0 }),
  body("status").optional().isIn(["active", "sold", "removed"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = items.findIndex(i => i.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Item not found" });
    items[idx] = { ...items[idx], ...req.body };
    res.json(items[idx]);
  }
);

// DELETE item
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = items.findIndex(i => i.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Item not found" });
  items.splice(idx, 1);
  res.status(204).send();
});

export { router as itemsRouter };