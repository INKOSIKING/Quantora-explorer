import { Router, Request, Response } from "express";
import { body, param, validationResult } from "express-validator";

const router = Router();
let products = [
  { id: 1, name: "QTX T-Shirt", price: 20, stock: 50, createdAt: new Date().toISOString() }
];

// GET all
router.get("/", (req: Request, res: Response) => res.json(products));

// GET one
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const product = products.find(p => p.id === Number(req.params.id));
  if (!product) return res.status(404).json({ error: "Product not found" });
  res.json(product);
});

// CREATE
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("price").isFloat({ gt: 0 }),
  body("stock").isInt({ min: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { name, price, stock } = req.body;
    if (products.some(p => p.name === name)) return res.status(409).json({ error: "Product name exists" });
    const product = { id: products.length + 1, name, price, stock, createdAt: new Date().toISOString() };
    products.push(product);
    res.status(201).json(product);
  }
);

// UPDATE
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("name").optional().isString().isLength({ min: 2 }),
  body("price").optional().isFloat({ gt: 0 }),
  body("stock").optional().isInt({ min: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = products.findIndex(p => p.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Product not found" });
    products[idx] = { ...products[idx], ...req.body };
    res.json(products[idx]);
  }
);

// DELETE
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = products.findIndex(p => p.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Product not found" });
  products.splice(idx, 1);
  res.status(204).send();
});

export { router as productsRouter };