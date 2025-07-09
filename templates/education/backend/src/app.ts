import express from "express";
import helmet from "helmet";
import cors from "cors";
import morgan from "morgan";
import { coursesRouter } from "./routes/courses";
import { enrollmentsRouter } from "./routes/enrollments";
import { gradesRouter } from "./routes/grades";
import { certificatesRouter } from "./routes/certificates";

const app = express();

app.use(cors());
app.use(helmet());
app.use(morgan("dev"));
app.use(express.json());

app.use("/api/courses", coursesRouter);
app.use("/api/enrollments", enrollmentsRouter);
app.use("/api/grades", gradesRouter);
app.use("/api/certificates", certificatesRouter);

app.get("/healthz", (_, res) => res.send("OK"));

export default app;