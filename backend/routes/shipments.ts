import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let shipments: Array<{
  id: number;
  origin: string;
  destination: string;
  status: string;
  createdAt: string;
}> = [];

// GET all shipments
router.get("/", (req, res) => res.json(shipments));

// GET single shipment
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const shipment = shipments.find(s => s.id === Number(req.params.id));
  if (!shipment) return res.status(404).json({ error: "Shipment not found" });
  res.json(shipment);
});

// CREATE shipment
router.post("/",
  body("origin").isString().notEmpty(),
  body("destination").isString().notEmpty(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { origin, destination } = req.body;
    const shipment = {
      id: shipments.length + 1,
      origin,
      destination,
      status: "created",
      createdAt: new Date().toISOString()
    };
    shipments.push(shipment);
    res.status(201).json(shipment);
  }
);

// UPDATE shipment status only
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["created", "in_transit", "delivered", "canceled"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = shipments.findIndex(s => s.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Shipment not found" });
    shipments[idx].status = req.body.status;
    res.json(shipments[idx]);
  }
);

// DELETE shipment
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = shipments.findIndex(s => s.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Shipment not found" });
  shipments.splice(idx, 1);
  res.status(204).send();
});

export { router as shipmentsRouter };