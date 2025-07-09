import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let patients: Array<{ id: number; name: string; dob: string; gender: string; createdAt: string }> = [];

// GET all patients
router.get("/", (req, res) => res.json(patients));

// GET single patient
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const patient = patients.find(p => p.id === Number(req.params.id));
  if (!patient) return res.status(404).json({ error: "Patient not found" });
  res.json(patient);
});

// CREATE patient (unique name+dob)
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("dob").isISO8601(),
  body("gender").isIn(["male", "female", "other"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { name, dob, gender } = req.body;
    if (patients.some(p => p.name === name && p.dob === dob))
      return res.status(409).json({ error: "Patient with this name and DOB already exists" });
    const patient = {
      id: patients.length + 1,
      name,
      dob,
      gender,
      createdAt: new Date().toISOString()
    };
    patients.push(patient);
    res.status(201).json(patient);
  }
);

// UPDATE patient (name, dob, gender)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("name").optional().isString().isLength({ min: 2 }),
  body("dob").optional().isISO8601(),
  body("gender").optional().isIn(["male", "female", "other"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = patients.findIndex(p => p.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Patient not found" });
    // Prevent duplicate name+dob
    if (
      (req.body.name || req.body.dob) &&
      patients.some(
        p =>
          p.id !== Number(req.params.id) &&
          (req.body.name ? p.name === req.body.name : p.name === patients[idx].name) &&
          (req.body.dob ? p.dob === req.body.dob : p.dob === patients[idx].dob)
      )
    )
      return res.status(409).json({ error: "Patient with this name and DOB already exists" });
    patients[idx] = { ...patients[idx], ...req.body };
    res.json(patients[idx]);
  }
);

// DELETE patient
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = patients.findIndex(p => p.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Patient not found" });
  patients.splice(idx, 1);
  res.status(204).send();
});

export { router as patientsRouter };