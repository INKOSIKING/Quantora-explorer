import express from "express";
import bodyParser from "body-parser";
import { productsRouter } from "./routes/products";
import { ordersRouter } from "./routes/orders";
import { usersRouter } from "./routes/users";
import { paymentsRouter } from "./routes/payments";

const app = express();
app.use(bodyParser.json());
app.use("/api/products", productsRouter);
app.use("/api/orders", ordersRouter);
app.use("/api/users", usersRouter);
app.use("/api/payments", paymentsRouter);

app.listen(3001, () => console.log("Ecommerce backend running on :3001"));