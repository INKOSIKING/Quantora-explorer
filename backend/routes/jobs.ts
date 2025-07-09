import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let jobs: Array<{ id: number; reportId: number; status: string; startedAt?: string; finishedAt?: string }> = [];

// GET all jobs
router.get("/", (req, res) => res.json(jobs));

// GET one job
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const job = jobs.find(j => j.id === Number(req.params.id));
  if (!job) return res.status(404).json({ error: "Job not found" });
  res.json(job);
});

// CREATE job (must reference existing report)
router.post("/",
  body("reportId").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { reportId } = req.body;
    // In real app: check that report exists
    // For demo: allow any reportId
    const job = {
      id: jobs.length + 1,
      reportId,
      status: "queued",
      startedAt: undefined,
      finishedAt: undefined
    };
    jobs.push(job);
    res.status(201).json(job);
  }
);

// UPDATE job (status, startedAt, finishedAt)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").optional().isIn(["queued", "running", "finished", "failed"]),
  body("startedAt").optional().isISO8601(),
  body("finishedAt").optional().isISO8601(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = jobs.findIndex(j => j.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Job not found" });
    jobs[idx] = { ...jobs[idx], ...req.body };
    res.json(jobs[idx]);
  }
);

// DELETE job
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = jobs.findIndex(j => j.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Job not found" });
  jobs.splice(idx, 1);
  res.status(204).send();
});

export { router as jobsRouter };