import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let orders: Array<{ id: number; userId: number; productId: number; quantity: number; status: string; createdAt: string }> = [];

// GET all orders
router.get("/", (req, res) => res.json(orders));

// GET single order
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const order = orders.find(o => o.id === Number(req.params.id));
  if (!order) return res.status(404).json({ error: "Order not found" });
  res.json(order);
});

// CREATE order
router.post("/",
  body("userId").isInt({ min: 1 }),
  body("productId").isInt({ min: 1 }),
  body("quantity").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { userId, productId, quantity } = req.body;
    // Business logic: prevent duplicate open order for same user/product
    if (orders.some(o => o.userId === userId && o.productId === productId && o.status === "pending"))
      return res.status(409).json({ error: "Order already exists and is pending" });
    const order = {
      id: orders.length + 1,
      userId,
      productId,
      quantity,
      status: "pending",
      createdAt: new Date().toISOString()
    };
    orders.push(order);
    res.status(201).json(order);
  }
);

// UPDATE order (only allow status change)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["pending", "paid", "shipped", "canceled"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = orders.findIndex(o => o.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Order not found" });
    orders[idx].status = req.body.status;
    res.json(orders[idx]);
  }
);

// DELETE order
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = orders.findIndex(o => o.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Order not found" });
  orders.splice(idx, 1);
  res.status(204).send();
});

export { router as ordersRouter };