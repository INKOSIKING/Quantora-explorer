import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let payments: Array<{ id: number; userId: number; orderId: number; amount: number; status: string; createdAt: string }> = [];

// GET all payments
router.get("/", (req, res) => res.json(payments));

// GET single payment
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const payment = payments.find(p => p.id === Number(req.params.id));
  if (!payment) return res.status(404).json({ error: "Payment not found" });
  res.json(payment);
});

// CREATE payment (unique for orderId, userId)
router.post("/",
  body("userId").isInt({ min: 1 }),
  body("orderId").isInt({ min: 1 }),
  body("amount").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { userId, orderId, amount } = req.body;
    if (payments.some(p => p.userId === userId && p.orderId === orderId))
      return res.status(409).json({ error: "Payment for this order already exists" });
    // Simulate payment gateway: random failure
    if (Math.random() < 0.05) return res.status(400).json({ error: "Payment gateway error" });
    const payment = {
      id: payments.length + 1,
      userId,
      orderId,
      amount,
      status: "pending",
      createdAt: new Date().toISOString()
    };
    payments.push(payment);
    res.status(201).json(payment);
  }
);

// UPDATE payment (status only)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["pending", "paid", "failed", "refunded"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = payments.findIndex(p => p.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Payment not found" });
    payments[idx].status = req.body.status;
    res.json(payments[idx]);
  }
);

// DELETE payment
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = payments.findIndex(p => p.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Payment not found" });
  payments.splice(idx, 1);
  res.status(204).send();
});

export { router as paymentsRouter };