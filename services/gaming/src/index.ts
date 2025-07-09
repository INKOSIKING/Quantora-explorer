import express from "express";
import { createGame, joinGame, getGames } from "./service";

const app = express();
app.use(express.json());

app.post("/game/create", async (req, res) => {
  const { creator, game } = req.body;
  const result = await createGame(creator, game);
  res.json(result);
});

app.post("/game/join", async (req, res) => {
  const { user, gameId } = req.body;
  const join = await joinGame(user, gameId);
  res.json(join);
});

app.get("/games", async (req, res) => {
  const games = await getGames();
  res.json(games);
});

app.listen(5300, () => console.log("Gaming Service running on :5300"));