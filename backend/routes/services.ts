import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let services: Array<{ id: number; name: string; description: string; status: string; createdAt: string }> = [];

// GET all services
router.get("/", (req, res) => res.json(services));

// GET single service
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const service = services.find(s => s.id === Number(req.params.id));
  if (!service) return res.status(404).json({ error: "Service not found" });
  res.json(service);
});

// CREATE service (unique name)
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("description").optional().isString(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { name, description } = req.body;
    if (services.some(s => s.name === name))
      return res.status(409).json({ error: "Service name already exists" });
    const service = {
      id: services.length + 1,
      name,
      description,
      status: "active",
      createdAt: new Date().toISOString()
    };
    services.push(service);
    res.status(201).json(service);
  }
);

// UPDATE service (name, description, status)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("name").optional().isString().isLength({ min: 2 }),
  body("description").optional().isString(),
  body("status").optional().isIn(["active", "inactive", "archived"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = services.findIndex(s => s.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Service not found" });
    // Prevent duplicate name
    if (req.body.name && services.some(s => s.name === req.body.name && s.id !== Number(req.params.id)))
      return res.status(409).json({ error: "Service name already exists" });
    services[idx] = { ...services[idx], ...req.body };
    res.json(services[idx]);
  }
);

// DELETE service
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = services.findIndex(s => s.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Service not found" });
  services.splice(idx, 1);
  res.status(204).send();
});

export { router as servicesRouter };