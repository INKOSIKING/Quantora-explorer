import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let courses: Array<{ id: number; title: string; description: string; status: string; createdAt: string }> = [];

// GET all courses
router.get("/", (req, res) => res.json(courses));

// GET single course
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const course = courses.find(c => c.id === Number(req.params.id));
  if (!course) return res.status(404).json({ error: "Course not found" });
  res.json(course);
});

// CREATE course (unique title)
router.post("/",
  body("title").isString().isLength({ min: 2 }),
  body("description").optional().isString(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { title, description } = req.body;
    if (courses.some(c => c.title === title))
      return res.status(409).json({ error: "Course title already exists" });
    const course = {
      id: courses.length + 1,
      title,
      description,
      status: "active",
      createdAt: new Date().toISOString()
    };
    courses.push(course);
    res.status(201).json(course);
  }
);

// UPDATE course (title, description, status)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("title").optional().isString().isLength({ min: 2 }),
  body("description").optional().isString(),
  body("status").optional().isIn(["active", "archived"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = courses.findIndex(c => c.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Course not found" });
    // Prevent duplicate title
    if (req.body.title && courses.some(c => c.title === req.body.title && c.id !== Number(req.params.id)))
      return res.status(409).json({ error: "Course title already exists" });
    courses[idx] = { ...courses[idx], ...req.body };
    res.json(courses[idx]);
  }
);

// DELETE course
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = courses.findIndex(c => c.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Course not found" });
  courses.splice(idx, 1);
  res.status(204).send();
});

export { router as coursesRouter };