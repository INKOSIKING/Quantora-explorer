import express from "express";
import { authenticateJWT, requireRoles } from "../../api-gateway/src/middleware/auth";
import { aiRouter } from "./routes/ai";
const app = express();

app.use(authenticateJWT);
app.use("/ai", aiRouter);

// Admin-only route
app.get("/ai/admin/stats", requireRoles("admin"), (req, res) => { /* ... */ });