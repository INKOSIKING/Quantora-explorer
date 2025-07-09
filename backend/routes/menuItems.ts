import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let menuItems: Array<{ id: number; name: string; price: number; description: string; available: boolean; createdAt: string }> = [];

// GET all menu items
router.get("/", (req, res) => res.json(menuItems));

// GET single menu item
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const item = menuItems.find(i => i.id === Number(req.params.id));
  if (!item) return res.status(404).json({ error: "Menu item not found" });
  res.json(item);
});

// CREATE menu item
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("price").isFloat({ gt: 0 }),
  body("description").optional().isString(),
  body("available").isBoolean(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { name, price, description, available } = req.body;
    if (menuItems.some(i => i.name === name))
      return res.status(409).json({ error: "Menu item with this name already exists" });
    const item = {
      id: menuItems.length + 1,
      name, price, description, available,
      createdAt: new Date().toISOString()
    };
    menuItems.push(item);
    res.status(201).json(item);
  }
);

// UPDATE menu item
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("name").optional().isString().isLength({ min: 2 }),
  body("price").optional().isFloat({ gt: 0 }),
  body("description").optional().isString(),
  body("available").optional().isBoolean(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = menuItems.findIndex(i => i.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Menu item not found" });
    // Prevent duplicate name
    if (req.body.name && menuItems.some(i => i.name === req.body.name && i.id !== Number(req.params.id)))
      return res.status(409).json({ error: "Menu item with this name already exists" });
    menuItems[idx] = { ...menuItems[idx], ...req.body };
    res.json(menuItems[idx]);
  }
);

// DELETE menu item
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = menuItems.findIndex(i => i.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Menu item not found" });
  menuItems.splice(idx, 1);
  res.status(204).send();
});

export { router as menuItemsRouter };