import express from "express";
import { recordEvent, getStats } from "./service";

const app = express();
app.use(express.json());

app.post("/event", async (req, res) => {
  const { type, data } = req.body;
  await recordEvent(type, data);
  res.json({ status: "recorded" });
});

app.get("/stats", async (req, res) => {
  const stats = await getStats();
  res.json(stats);
});

app.listen(6000, () => console.log("Analytics Service running on :6000"));