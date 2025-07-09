import { Router } from "express";
const router = Router();

let orders = [];

router.post("/", (req, res) => {
  const order = { ...req.body, id: orders.length + 1, status: "pending", createdAt: new Date().toISOString() };
  orders.push(order);
  res.status(201).json(order);
});

router.get("/:id", (req, res) => {
  const order = orders.find(o => o.id === Number(req.params.id));
  if (order) res.json(order);
  else res.status(404).json({ error: "Not found" });
});

router.get("/", (req, res) => res.json(orders));

router.put("/:id/status", (req, res) => {
  const idx = orders.findIndex(o => o.id === Number(req.params.id));
  if (idx > -1) {
    orders[idx].status = req.body.status;
    res.json(orders[idx]);
  } else res.status(404).json({ error: "Not found" });
});

export { router as ordersRouter };