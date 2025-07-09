import express from "express";
const app = express();
app.get("/", (req, res) => res.send("Bridge Hub API"));
app.listen(9004, () => console.log("Bridge Hub API running on :9004"));