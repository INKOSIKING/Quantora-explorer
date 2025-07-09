import express from "express";
import { createProposal, voteProposal, getProposals } from "./service";

const app = express();
app.use(express.json());

app.post("/proposal", async (req, res) => {
  const { proposer, details } = req.body;
  const proposal = await createProposal(proposer, details);
  res.json(proposal);
});

app.post("/vote", async (req, res) => {
  const { voter, proposalId, vote } = req.body;
  const result = await voteProposal(voter, proposalId, vote);
  res.json(result);
});

app.get("/proposals", async (req, res) => {
  const proposals = await getProposals();
  res.json(proposals);
});

app.listen(5400, () => console.log("GovTech Service running on :5400"));