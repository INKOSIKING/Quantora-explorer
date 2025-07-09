import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let foodOrders: Array<{ id: number; menuItemId: number; userId: number; quantity: number; status: string; createdAt: string }> = [];

// GET all food orders
router.get("/", (req, res) => res.json(foodOrders));

// GET single food order
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const order = foodOrders.find(o => o.id === Number(req.params.id));
  if (!order) return res.status(404).json({ error: "Order not found" });
  res.json(order);
});

// CREATE food order
router.post("/",
  body("menuItemId").isInt({ min: 1 }),
  body("userId").isInt({ min: 1 }),
  body("quantity").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { menuItemId, userId, quantity } = req.body;
    // Only one pending order per user/menuItem
    if (foodOrders.some(o => o.menuItemId === menuItemId && o.userId === userId && o.status === "pending"))
      return res.status(409).json({ error: "Pending order already exists for this menu item and user" });
    const order = {
      id: foodOrders.length + 1,
      menuItemId, userId, quantity,
      status: "pending",
      createdAt: new Date().toISOString()
    };
    foodOrders.push(order);
    res.status(201).json(order);
  }
);

// UPDATE food order (status only)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["pending", "preparing", "served", "canceled"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = foodOrders.findIndex(o => o.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Order not found" });
    foodOrders[idx].status = req.body.status;
    res.json(foodOrders[idx]);
  }
);

// DELETE food order
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = foodOrders.findIndex(o => o.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Order not found" });
  foodOrders.splice(idx, 1);
  res.status(204).send();
});

export { router as foodOrdersRouter };