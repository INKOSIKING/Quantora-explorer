import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let doctors: Array<{ id: number; name: string; specialty: string; email: string; joinedAt: string }> = [];

// GET all doctors
router.get("/", (req, res) => res.json(doctors));

// GET single doctor
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const doctor = doctors.find(d => d.id === Number(req.params.id));
  if (!doctor) return res.status(404).json({ error: "Doctor not found" });
  res.json(doctor);
});

// CREATE doctor (unique email)
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("specialty").isString().isLength({ min: 2 }),
  body("email").isEmail(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { email } = req.body;
    if (doctors.some(d => d.email === email))
      return res.status(409).json({ error: "Doctor email already exists" });
    const doctor = {
      id: doctors.length + 1,
      ...req.body,
      joinedAt: new Date().toISOString()
    };
    doctors.push(doctor);
    res.status(201).json(doctor);
  }
);

// UPDATE doctor (name, specialty, email)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("name").optional().isString().isLength({ min: 2 }),
  body("specialty").optional().isString().isLength({ min: 2 }),
  body("email").optional().isEmail(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = doctors.findIndex(d => d.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Doctor not found" });
    if (req.body.email && doctors.some(d => d.email === req.body.email && d.id !== Number(req.params.id)))
      return res.status(409).json({ error: "Doctor email already exists" });
    doctors[idx] = { ...doctors[idx], ...req.body };
    res.json(doctors[idx]);
  }
);

// DELETE doctor
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = doctors.findIndex(d => d.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Doctor not found" });
  doctors.splice(idx, 1);
  res.status(204).send();
});

export { router as doctorsRouter };