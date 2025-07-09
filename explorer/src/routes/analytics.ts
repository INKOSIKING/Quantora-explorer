import { Router } from "express";
import { getUserPortfolio } from "../portfolio";
import { getUserWatchlist, addToWatchlist } from "../watchlist";
import { getTokenHistory } from "../historical_charts";

const router = Router();

router.get("/portfolio", async (req, res) => {
  const userId = req.user.id;
  const data = await getUserPortfolio(userId);
  res.json(data);
});

router.get("/watchlist", async (req, res) => {
  const userId = req.user.id;
  const data = await getUserWatchlist(userId);
  res.json(data.rows.map(r => r.address));
});

router.post("/watchlist", async (req, res) => {
  const userId = req.user.id;
  const { address } = req.body;
  await addToWatchlist(userId, address);
  res.status(201).end();
});

router.get("/token/:symbol/history", async (req, res) => {
  const { symbol } = req.params;
  const { interval } = req.query;
  const data = await getTokenHistory(symbol, interval as string);
  res.json(data.rows);
});

export default router;