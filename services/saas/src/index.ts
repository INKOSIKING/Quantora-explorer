import express from "express";
import { createSubscription, cancelSubscription, getSubscriptions } from "./service";

const app = express();
app.use(express.json());

app.post("/subscribe", async (req, res) => {
  const { user, plan } = req.body;
  const subscription = await createSubscription(user, plan);
  res.json(subscription);
});

app.post("/unsubscribe", async (req, res) => {
  const { user } = req.body;
  const result = await cancelSubscription(user);
  res.json(result);
});

app.get("/subscriptions", async (req, res) => {
  const subs = await getSubscriptions();
  res.json(subs);
});

app.listen(5200, () => console.log("SaaS Service running on :5200"));