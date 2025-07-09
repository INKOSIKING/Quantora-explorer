import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();
let shipments = [];
router.get("/", (req, res) => res.json(shipments));
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const s = shipments.find(x => x.id === Number(req.params.id));
  if (!s) return res.status(404).json({ error: "Shipment not found" });
  res.json(s);
});
router.post("/", body("origin").isString(), body("destination").isString(), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const { origin, destination } = req.body;
  const s = { id: shipments.length + 1, origin, destination, status: "created", createdAt: new Date().toISOString() };
  shipments.push(s);
  res.status(201).json(s);
});
// UPDATE/DELETE as above...
export { router as shipmentsRouter };