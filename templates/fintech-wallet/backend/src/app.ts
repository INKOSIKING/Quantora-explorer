import express from "express";
import helmet from "helmet";
import cors from "cors";
import morgan from "morgan";
import rateLimit from "express-rate-limit";
import { usersRouter } from "./routes/users";
import { accountsRouter } from "./routes/accounts";
import { transactionsRouter } from "./routes/transactions";
import { kycRouter } from "./routes/kyc";
import { adminRouter } from "./routes/admin";
import { authMiddleware, adminMiddleware } from "./middleware/auth";
import swaggerUi from "swagger-ui-express";
import swaggerSpec from "../docs/swagger.json";

const app = express();
app.use(cors());
app.use(helmet());
app.use(morgan("tiny"));
app.use(express.json());
app.use(rateLimit({ windowMs: 60000, max: 100 }));

app.use("/api/docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.use("/api/users", usersRouter);
app.use("/api/accounts", authMiddleware, accountsRouter);
app.use("/api/transactions", authMiddleware, transactionsRouter);
app.use("/api/kyc", authMiddleware, kycRouter);
app.use("/api/admin", authMiddleware, adminMiddleware, adminRouter);
app.get("/healthz", (_, res) => res.send("OK"));
export default app;