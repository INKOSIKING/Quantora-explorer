import { Router } from "express";
import { Staking } from "../staking";
import { addPoints, getPoints } from "../loyalty";
import { createReferral, getReferralStats } from "../referral";

const router = Router();

router.post("/stake", async (req, res) => {
  const { amount } = req.body;
  const userId = req.user.id;
  // Assume staking instance is available
  staking.stake(userId, amount);
  res.status(201).end();
});
router.get("/stake/rewards", async (req, res) => {
  const userId = req.user.id;
  res.json({ rewards: staking.calc_rewards(userId) });
});

router.post("/referral", async (req, res) => {
  await createReferral(req.user.id, req.body.referredId);
  res.status(201).end();
});
router.get("/referral/stats", async (req, res) => {
  res.json(await getReferralStats(req.user.id));
});

router.post("/loyalty/add", async (req, res) => {
  await addPoints(req.user.id, req.body.points);
  res.status(201).end();
});
router.get("/loyalty", async (req, res) => {
  res.json({ points: await getPoints(req.user.id) });
});

export default router;