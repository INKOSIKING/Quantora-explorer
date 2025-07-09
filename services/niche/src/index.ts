import express from "express";
import { createNiche, getNiches } from "./service";

const app = express();
app.use(express.json());

app.post("/create", async (req, res) => {
  const { owner, type, data } = req.body;
  const result = await createNiche(owner, type, data);
  res.json(result);
});

app.get("/all", async (req, res) => {
  const niches = await getNiches();
  res.json(niches);
});

app.listen(5700, () => console.log("Niche Service running on :5700"));