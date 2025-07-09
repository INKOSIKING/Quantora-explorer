import express from "express";
import { registerDoctor, bookAppointment, getDoctors } from "./service";

const app = express();
app.use(express.json());

app.post("/doctor/register", async (req, res) => {
  const { doctor, specialty } = req.body;
  const result = await registerDoctor(doctor, specialty);
  res.json(result);
});

app.post("/appointment/book", async (req, res) => {
  const { patient, doctorId, time } = req.body;
  const appointment = await bookAppointment(patient, doctorId, time);
  res.json(appointment);
});

app.get("/doctors", async (req, res) => {
  const doctors = await getDoctors();
  res.json(doctors);
});

app.listen(5100, () => console.log("Healthcare Service running on :5100"));