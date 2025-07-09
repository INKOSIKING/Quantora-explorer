import express from "express";
const app = express();
app.get("/", (req, res) => res.send("Platform API Gateway"));
app.listen(9000, () => console.log("Platform API Gateway running on :9000"));