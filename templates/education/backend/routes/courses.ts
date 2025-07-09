import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();
let courses = [];
router.get("/", (req, res) => res.json(courses));
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const c = courses.find(x => x.id === Number(req.params.id));
  if (!c) return res.status(404).json({ error: "Course not found" });
  res.json(c);
});
router.post("/", body("title").isString().isLength({ min: 2 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const { title } = req.body;
  const c = { id: courses.length + 1, title, createdAt: new Date().toISOString() };
  courses.push(c);
  res.status(201).json(c);
});
// UPDATE/DELETE as above...
export { router as coursesRouter };