import express from "express";
import { createShipment, trackShipment, getShipments } from "./service";

const app = express();
app.use(express.json());

app.post("/shipment/create", async (req, res) => {
  const { sender, shipment } = req.body;
  const result = await createShipment(sender, shipment);
  res.json(result);
});

app.get("/shipment/track/:id", async (req, res) => {
  const { id } = req.params;
  const status = await trackShipment(Number(id));
  res.json(status);
});

app.get("/shipments", async (req, res) => {
  const shipments = await getShipments();
  res.json(shipments);
});

app.listen(5600, () => console.log("Logistics Service running on :5600"));