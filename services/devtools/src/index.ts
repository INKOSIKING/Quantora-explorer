import express from "express";
import { createApiKey, revokeApiKey, getApiKeys } from "./service";

const app = express();
app.use(express.json());

app.post("/apikey/create", async (req, res) => {
  const { user } = req.body;
  const key = await createApiKey(user);
  res.json(key);
});

app.post("/apikey/revoke", async (req, res) => {
  const { user, key } = req.body;
  const result = await revokeApiKey(user, key);
  res.json(result);
});

app.get("/apikeys/:user", async (req, res) => {
  const { user } = req.params;
  const keys = await getApiKeys(user);
  res.json(keys);
});

app.listen(5800, () => console.log("DevTools Service running on :5800"));