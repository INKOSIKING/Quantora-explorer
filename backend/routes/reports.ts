import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let reports: Array<{ id: number; datasetId: number; title: string; status: string; createdAt: string }> = [];

// GET all reports
router.get("/", (req, res) => res.json(reports));

// GET one report
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const report = reports.find(r => r.id === Number(req.params.id));
  if (!report) return res.status(404).json({ error: "Report not found" });
  res.json(report);
});

// CREATE report (must reference existing dataset)
router.post("/",
  body("datasetId").isInt({ min: 1 }),
  body("title").isString().isLength({ min: 2 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { datasetId, title } = req.body;
    // In real app: check that dataset exists
    // For demo: allow any datasetId
    const report = {
      id: reports.length + 1,
      datasetId,
      title,
      status: "pending",
      createdAt: new Date().toISOString()
    };
    reports.push(report);
    res.status(201).json(report);
  }
);

// UPDATE report (status or title)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").optional().isIn(["pending", "processing", "done", "failed"]),
  body("title").optional().isString().isLength({ min: 2 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = reports.findIndex(r => r.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Report not found" });
    reports[idx] = { ...reports[idx], ...req.body };
    res.json(reports[idx]);
  }
);

// DELETE report
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = reports.findIndex(r => r.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Report not found" });
  reports.splice(idx, 1);
  res.status(204).send();
});

export { router as reportsRouter };