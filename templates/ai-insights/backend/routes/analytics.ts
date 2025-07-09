import { Router } from "express";
import { spawn } from "child_process";
const router = Router();

router.post("/insights", async (req, res) => {
  const { dataset } = req.body;
  // In prod, call real ML pipeline or microservice
  // e.g. spawn Python process or use a job queue
  if (!Array.isArray(dataset)) return res.status(400).json({ error: "Invalid dataset" });
  // Mocked AI output
  const insights = {
    summary: "Detected growth trend and seasonal dip",
    anomalies: [{ idx: 4, value: dataset[4], type: "outlier" }]
  };
  res.json(insights);
});

export { router as analyticsRouter };