import express from "express";
import { addTrip, bookTrip, getTrips } from "./service";

const app = express();
app.use(express.json());

app.post("/trip/add", async (req, res) => {
  const { provider, trip } = req.body;
  const result = await addTrip(provider, trip);
  res.json(result);
});

app.post("/trip/book", async (req, res) => {
  const { user, tripId } = req.body;
  const booking = await bookTrip(user, tripId);
  res.json(booking);
});

app.get("/trips", async (req, res) => {
  const trips = await getTrips();
  res.json(trips);
});

app.listen(5500, () => console.log("Travel Service running on :5500"));