import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let marketplaceOrders: Array<{ id: number; itemId: number; buyerId: number; quantity: number; status: string; createdAt: string }> = [];

// GET all orders
router.get("/", (req, res) => res.json(marketplaceOrders));

// GET single order
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const order = marketplaceOrders.find(o => o.id === Number(req.params.id));
  if (!order) return res.status(404).json({ error: "Order not found" });
  res.json(order);
});

// CREATE order
router.post("/",
  body("itemId").isInt({ min: 1 }),
  body("buyerId").isInt({ min: 1 }),
  body("quantity").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { itemId, buyerId, quantity } = req.body;
    // Only one pending order per buyer/item
    if (marketplaceOrders.some(o => o.itemId === itemId && o.buyerId === buyerId && o.status === "pending"))
      return res.status(409).json({ error: "Pending order already exists for this item and buyer" });
    const order = {
      id: marketplaceOrders.length + 1,
      itemId, buyerId, quantity,
      status: "pending",
      createdAt: new Date().toISOString()
    };
    marketplaceOrders.push(order);
    res.status(201).json(order);
  }
);

// UPDATE order (status only)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["pending", "paid", "shipped", "completed", "canceled"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = marketplaceOrders.findIndex(o => o.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Order not found" });
    marketplaceOrders[idx].status = req.body.status;
    res.json(marketplaceOrders[idx]);
  }
);

// DELETE order
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = marketplaceOrders.findIndex(o => o.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Order not found" });
  marketplaceOrders.splice(idx, 1);
  res.status(204).send();
});

export { router as marketplaceOrdersRouter };