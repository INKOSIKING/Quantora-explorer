import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();
let services = [];
router.get("/", (req, res) => res.json(services));
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const s = services.find(x => x.id === Number(req.params.id));
  if (!s) return res.status(404).json({ error: "Service not found" });
  res.json(s);
});
router.post("/", body("name").isString().isLength({ min: 2 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const { name } = req.body;
  const s = { id: services.length + 1, name, createdAt: new Date().toISOString() };
  services.push(s);
  res.status(201).json(s);
});
// UPDATE/DELETE as above...
export { router as servicesRouter };