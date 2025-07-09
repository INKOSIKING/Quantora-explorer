import express from "express";
import helmet from "helmet";
import cors from "cors";
import rateLimit from "express-rate-limit";
import bodyParser from "body-parser";
import { authRouter } from "./routes/auth";
import { usersRouter } from "./routes/users";
import { passwordResetRouter } from "./routes/passwordReset";
import { oauthRouter } from "./routes/oauth";
import { setupSwagger } from "./docs/swagger";
import passport from "passport";
import "./passport"; // Passport strategies

const app = express();
app.use(helmet());
app.use(cors());
app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 200 }));
app.use(bodyParser.json());
app.use(passport.initialize());

app.use("/auth", authRouter);
app.use("/users", usersRouter);
app.use("/password-reset", passwordResetRouter);
app.use("/oauth", oauthRouter);

setupSwagger(app);

app.get("/healthz", (_, res) => res.send("OK"));
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: err.message });
});

export default app;