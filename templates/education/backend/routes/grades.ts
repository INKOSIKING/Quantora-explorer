import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let grades: Array<{ id: number; enrollmentId: number; grade: number }> = [];

// GET all grades
router.get("/", (req, res) => res.json(grades));

// GET single grade
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const grade = grades.find(g => g.id === Number(req.params.id));
  if (!grade) return res.status(404).json({ error: "Grade not found" });
  res.json(grade);
});

// CREATE grade (grade 0-100)
router.post("/",
  body("enrollmentId").isInt({ min: 1 }),
  body("grade").isFloat({ min: 0, max: 100 }),
  (req, res) => {
    const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { enrollmentId, grade } = req.body;
    if (grades.some(g => g.enrollmentId === enrollmentId))
      return res.status(409).json({ error: "Grade already assigned for this enrollment" });
    const g = { id: grades.length + 1, enrollmentId, grade };
    grades.push(g);
    res.status(201).json(g);
  }
);

// UPDATE grade (grade 0-100)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("grade").isFloat({ min: 0, max: 100 }),
  (req, res) => {
    const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = grades.findIndex(g => g.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Grade not found" });
    grades[idx].grade = req.body.grade;
    res.json(grades[idx]);
  }
);

// DELETE grade
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = grades.findIndex(g => g.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Grade not found" });
  grades.splice(idx, 1);
  res.status(204).send();
});

export { router as gradesRouter };