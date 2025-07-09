import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let applications: Array<{ id: number; serviceId: number; userId: number; status: string; submittedAt: string }> = [];

// GET all applications
router.get("/", (req, res) => res.json(applications));

// GET single application
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const application = applications.find(a => a.id === Number(req.params.id));
  if (!application) return res.status(404).json({ error: "Application not found" });
  res.json(application);
});

// CREATE application (one pending per user/service)
router.post("/",
  body("serviceId").isInt({ min: 1 }),
  body("userId").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { serviceId, userId } = req.body;
    if (applications.some(a => a.serviceId === serviceId && a.userId === userId && a.status === "pending"))
      return res.status(409).json({ error: "Pending application already exists for this service and user" });
    const application = {
      id: applications.length + 1,
      serviceId,
      userId,
      status: "pending",
      submittedAt: new Date().toISOString()
    };
    applications.push(application);
    res.status(201).json(application);
  }
);

// UPDATE application (status only)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["pending", "approved", "rejected", "withdrawn"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = applications.findIndex(a => a.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Application not found" });
    applications[idx].status = req.body.status;
    res.json(applications[idx]);
  }
);

// DELETE application
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = applications.findIndex(a => a.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Application not found" });
  applications.splice(idx, 1);
  res.status(204).send();
});

export { router as applicationsRouter };