import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let enrollments: Array<{ id: number; userId: number; courseId: number; enrolledAt: string }> = [];

// GET all enrollments
router.get("/", (req, res) => res.json(enrollments));

// GET single enrollment
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const enrollment = enrollments.find(e => e.id === Number(req.params.id));
  if (!enrollment) return res.status(404).json({ error: "Enrollment not found" });
  res.json(enrollment);
});

// CREATE enrollment (prevent duplicate)
router.post("/",
  body("userId").isInt({ min: 1 }),
  body("courseId").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { userId, courseId } = req.body;
    if (enrollments.some(e => e.userId === userId && e.courseId === courseId))
      return res.status(409).json({ error: "User already enrolled in this course" });
    const enrollment = { id: enrollments.length + 1, userId, courseId, enrolledAt: new Date().toISOString() };
    enrollments.push(enrollment);
    res.status(201).json(enrollment);
  }
);

// UPDATE enrollment (only courseId allowed)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("courseId").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = enrollments.findIndex(e => e.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Enrollment not found" });
    // Prevent duplicate
    const { userId } = enrollments[idx];
    if (enrollments.some(e => e.userId === userId && e.courseId === req.body.courseId))
      return res.status(409).json({ error: "User already enrolled in this course" });
    enrollments[idx].courseId = req.body.courseId;
    res.json(enrollments[idx]);
  }
);

// DELETE enrollment
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = enrollments.findIndex(e => e.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Enrollment not found" });
  enrollments.splice(idx, 1);
  res.status(204).send();
});

export { router as enrollmentsRouter };