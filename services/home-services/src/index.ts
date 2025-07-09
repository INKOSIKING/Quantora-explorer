import express from "express";
import { listProvider, bookService, getProviders } from "./service";

const app = express();
app.use(express.json());

app.post("/provider/list", async (req, res) => {
  const { provider, service } = req.body;
  const result = await listProvider(provider, service);
  res.json(result);
});

app.post("/service/book", async (req, res) => {
  const { user, providerId, serviceType } = req.body;
  const booking = await bookService(user, providerId, serviceType);
  res.json(booking);
});

app.get("/providers", async (req, res) => {
  const providers = await getProviders();
  res.json(providers);
});

app.listen(4900, () => console.log("Home Services API running on :4900"));