import express from "express";
import helmet from "helmet";
import cors from "cors";
import rateLimit from "express-rate-limit";
import bodyParser from "body-parser";
import { authRouter } from "./routes/auth";
import { passwordResetRouter } from "./routes/passwordReset";
import { usersRouter } from "./routes/users";
import { authenticateJWT } from "./middleware/auth";
// ... import all your other routers ...

const app = express();
app.use(helmet());
app.use(cors());
app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 200 }));
app.use(bodyParser.json());

app.use("/auth", authRouter);
app.use("/auth/password-reset", passwordResetRouter);
app.use("/users", usersRouter);

// All API endpoints below require login
app.use(authenticateJWT);
// app.use("/admin", requireRoles("admin"), adminRouter); // for admin-only endpoints

// ... plug in all your business routers here ...

// Error handler as before
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: err.message });
});

export default app;