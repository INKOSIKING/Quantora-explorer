import express from "express";
import { analyzeBlock, queryLLM, fraudDetect } from "./service";

const app = express();
app.use(express.json());

app.post("/analyze/block", async (req, res) => {
  const { block } = req.body;
  const insights = await analyzeBlock(block);
  res.json({ insights });
});

app.post("/llm", async (req, res) => {
  const { prompt } = req.body;
  const answer = await queryLLM(prompt);
  res.json({ answer });
});

app.post("/fraud", async (req, res) => {
  const { tx } = req.body;
  const flagged = await fraudDetect(tx);
  res.json({ flagged });
});

app.listen(4400, () => console.log("AI Service running on :4400"));