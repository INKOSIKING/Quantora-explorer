import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let trackingEvents: Array<{
  id: number;
  shipmentId: number;
  status: string;
  timestamp: string;
  location: string;
}> = [];

// GET all tracking events
router.get("/", (req, res) => res.json(trackingEvents));

// GET single tracking event
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const event = trackingEvents.find(e => e.id === Number(req.params.id));
  if (!event) return res.status(404).json({ error: "Tracking event not found" });
  res.json(event);
});

// CREATE tracking event (status, timestamp, location)
router.post("/",
  body("shipmentId").isInt({ min: 1 }),
  body("status").isString().isLength({ min: 2 }),
  body("timestamp").isISO8601(),
  body("location").isString().isLength({ min: 2 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { shipmentId, status, timestamp, location } = req.body;
    // In real app, check that shipment exists!
    // For demo, allow any shipmentId
    const event = {
      id: trackingEvents.length + 1,
      shipmentId,
      status,
      timestamp,
      location
    };
    trackingEvents.push(event);
    res.status(201).json(event);
  }
);

// UPDATE tracking event (status, timestamp, location)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").optional().isString().isLength({ min: 2 }),
  body("timestamp").optional().isISO8601(),
  body("location").optional().isString().isLength({ min: 2 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = trackingEvents.findIndex(e => e.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Tracking event not found" });
    trackingEvents[idx] = { ...trackingEvents[idx], ...req.body };
    res.json(trackingEvents[idx]);
  }
);

// DELETE tracking event
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = trackingEvents.findIndex(e => e.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Tracking event not found" });
  trackingEvents.splice(idx, 1);
  res.status(204).send();
});

export { router as trackingEventsRouter };