import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let reservations: Array<{ id: number; userId: number; time: string; numGuests: number; status: string; createdAt: string }> = [];

// GET all reservations
router.get("/", (req, res) => res.json(reservations));

// GET single reservation
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const reservation = reservations.find(r => r.id === Number(req.params.id));
  if (!reservation) return res.status(404).json({ error: "Reservation not found" });
  res.json(reservation);
});

// CREATE reservation
router.post("/",
  body("userId").isInt({ min: 1 }),
  body("time").isISO8601(),
  body("numGuests").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { userId, time, numGuests } = req.body;
    // Only one pending reservation per user/time
    if (reservations.some(r => r.userId === userId && r.time === time && r.status === "pending"))
      return res.status(409).json({ error: "Pending reservation already exists for this user and time" });
    const reservation = {
      id: reservations.length + 1,
      userId, time, numGuests,
      status: "pending",
      createdAt: new Date().toISOString()
    };
    reservations.push(reservation);
    res.status(201).json(reservation);
  }
);

// UPDATE reservation (status, numGuests, time)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").optional().isIn(["pending", "confirmed", "completed", "canceled"]),
  body("numGuests").optional().isInt({ min: 1 }),
  body("time").optional().isISO8601(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = reservations.findIndex(r => r.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Reservation not found" });
    // Prevent duplicate pending reservation for user/time
    if (
      req.body.time &&
      reservations.some(
        r =>
          r.id !== Number(req.params.id) &&
          r.userId === reservations[idx].userId &&
          r.time === req.body.time &&
          r.status === "pending"
      )
    )
      return res.status(409).json({ error: "Pending reservation already exists for this user and time" });
    reservations[idx] = { ...reservations[idx], ...req.body };
    res.json(reservations[idx]);
  }
);

// DELETE reservation
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = reservations.findIndex(r => r.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Reservation not found" });
  reservations.splice(idx, 1);
  res.status(204).send();
});

export { router as reservationsRouter };