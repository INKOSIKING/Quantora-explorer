import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let prescriptions: Array<{ id: number; patientId: number; doctorId: number; medication: string; dosage: string; status: string; issuedAt: string }> = [];

// GET all prescriptions
router.get("/", (req, res) => res.json(prescriptions));

// GET single prescription
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const rx = prescriptions.find(p => p.id === Number(req.params.id));
  if (!rx) return res.status(404).json({ error: "Prescription not found" });
  res.json(rx);
});

// CREATE prescription (unique per patient/medication/status pending)
router.post("/",
  body("patientId").isInt({ min: 1 }),
  body("doctorId").isInt({ min: 1 }),
  body("medication").isString().isLength({ min: 2 }),
  body("dosage").isString().isLength({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { patientId, medication } = req.body;
    if (prescriptions.some(p => p.patientId === patientId && p.medication === medication && p.status === "pending"))
      return res.status(409).json({ error: "Pending prescription already exists for this patient and medication" });
    const rx = {
      id: prescriptions.length + 1,
      ...req.body,
      status: "pending",
      issuedAt: new Date().toISOString()
    };
    prescriptions.push(rx);
    res.status(201).json(rx);
  }
);

// UPDATE prescription (status, dosage)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").optional().isIn(["pending", "filled", "canceled"]),
  body("dosage").optional().isString().isLength({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = prescriptions.findIndex(p => p.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Prescription not found" });
    prescriptions[idx] = { ...prescriptions[idx], ...req.body };
    res.json(prescriptions[idx]);
  }
);

// DELETE prescription
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = prescriptions.findIndex(p => p.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Prescription not found" });
  prescriptions.splice(idx, 1);
  res.status(204).send();
});

export { router as prescriptionsRouter };