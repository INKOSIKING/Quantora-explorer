import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let appointments: Array<{ id: number; patientId: number; doctorId: number; time: string; status: string; createdAt: string }> = [];

// GET all appointments
router.get("/", (req, res) => res.json(appointments));

// GET single appointment
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const appt = appointments.find(a => a.id === Number(req.params.id));
  if (!appt) return res.status(404).json({ error: "Appointment not found" });
  res.json(appt);
});

// CREATE appointment (one pending per patient/time)
router.post("/",
  body("patientId").isInt({ min: 1 }),
  body("doctorId").isInt({ min: 1 }),
  body("time").isISO8601(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { patientId, doctorId, time } = req.body;
    if (appointments.some(a => a.patientId === patientId && a.time === time && a.status === "scheduled"))
      return res.status(409).json({ error: "Patient already has a scheduled appointment at this time" });
    const appt = {
      id: appointments.length + 1,
      patientId,
      doctorId,
      time,
      status: "scheduled",
      createdAt: new Date().toISOString()
    };
    appointments.push(appt);
    res.status(201).json(appt);
  }
);

// UPDATE appointment (status, time, doctor)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").optional().isIn(["scheduled", "completed", "canceled"]),
  body("doctorId").optional().isInt({ min: 1 }),
  body("time").optional().isISO8601(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = appointments.findIndex(a => a.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Appointment not found" });
    // Prevent double scheduling
    if (
      (req.body.time || req.body.patientId) &&
      appointments.some(
        a =>
          a.id !== Number(req.params.id) &&
          (req.body.patientId ? a.patientId === req.body.patientId : a.patientId === appointments[idx].patientId) &&
          (req.body.time ? a.time === req.body.time : a.time === appointments[idx].time) &&
          a.status === "scheduled"
      )
    )
      return res.status(409).json({ error: "Patient already has a scheduled appointment at this time" });
    appointments[idx] = { ...appointments[idx], ...req.body };
    res.json(appointments[idx]);
  }
);

// DELETE appointment
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = appointments.findIndex(a => a.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Appointment not found" });
  appointments.splice(idx, 1);
  res.status(204).send();
});

export { router as appointmentsRouter };