import { Router } from "express";
const router = Router();
let stakers = [];
router.post("/", (req, res) => {
  const stake = { ...req.body, id: stakers.length + 1, stakedAt: new Date().toISOString() };
  stakers.push(stake);
  res.status(201).json(stake);
});
router.get("/", (req, res) => res.json(stakers));
export { router as stakingRouter };