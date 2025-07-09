import express from "express";
import { sendNotification, subscribe, unsubscribe } from "./service";

const app = express();
app.use(express.json());

app.post("/subscribe", async (req, res) => {
  const { address, type, endpoint } = req.body;
  await subscribe(address, type, endpoint);
  res.json({ status: "subscribed" });
});

app.post("/unsubscribe", async (req, res) => {
  const { address, type } = req.body;
  await unsubscribe(address, type);
  res.json({ status: "unsubscribed" });
});

app.post("/notify", async (req, res) => {
  const { address, payload } = req.body;
  await sendNotification(address, payload);
  res.json({ status: "notified" });
});

app.listen(4300, () => console.log("Notifications API running on :4300"));