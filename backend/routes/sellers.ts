import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let sellers: Array<{ id: number; name: string; email: string; joinedAt: string }> = [];

// GET all sellers
router.get("/", (req, res) => res.json(sellers));

// GET single seller
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const seller = sellers.find(s => s.id === Number(req.params.id));
  if (!seller) return res.status(404).json({ error: "Seller not found" });
  res.json(seller);
});

// CREATE seller (unique email)
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("email").isEmail(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { email } = req.body;
    if (sellers.some(s => s.email === email))
      return res.status(409).json({ error: "Seller email already exists" });
    const seller = {
      id: sellers.length + 1,
      ...req.body,
      joinedAt: new Date().toISOString()
    };
    sellers.push(seller);
    res.status(201).json(seller);
  }
);

// UPDATE seller (name, email)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("name").optional().isString().isLength({ min: 2 }),
  body("email").optional().isEmail(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = sellers.findIndex(s => s.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Seller not found" });
    if (req.body.email && sellers.some(s => s.email === req.body.email && s.id !== Number(req.params.id)))
      return res.status(409).json({ error: "Seller email already exists" });
    sellers[idx] = { ...sellers[idx], ...req.body };
    res.json(sellers[idx]);
  }
);

// DELETE seller
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = sellers.findIndex(s => s.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Seller not found" });
  sellers.splice(idx, 1);
  res.status(204).send();
});

export { router as sellersRouter };