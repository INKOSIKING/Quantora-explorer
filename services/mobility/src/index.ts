import express from "express";
import { registerVehicle, bookRide, getAvailableVehicles } from "./service";

const app = express();
app.use(express.json());

app.post("/vehicle/register", async (req, res) => {
  const { owner, vehicle } = req.body;
  const result = await registerVehicle(owner, vehicle);
  res.json(result);
});

app.post("/ride/book", async (req, res) => {
  const { user, vehicleId, from, to } = req.body;
  const ride = await bookRide(user, vehicleId, from, to);
  res.json(ride);
});

app.get("/vehicles", async (req, res) => {
  const vehicles = await getAvailableVehicles();
  res.json(vehicles);
});

app.listen(4800, () => console.log("Mobility Service running on :4800"));