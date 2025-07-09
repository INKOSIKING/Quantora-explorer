import express from "express";
import { ApolloServer } from "apollo-server-express";
import { typeDefs } from "./schema";
import { resolvers } from "./resolvers";
import { createProxyMiddleware } from "http-proxy-middleware";
import { authMiddleware, errorHandler, rateLimiter } from "./middleware";
import morgan from "morgan";

const app = express();

app.use(morgan("combined"));
app.use(rateLimiter);
app.use(authMiddleware);

// Proxy REST routes to microservices
app.use("/dex", createProxyMiddleware({ target: "http://quantorax-api:4001", changeOrigin: true }));
app.use("/chain", createProxyMiddleware({ target: "http://quantora-chain:9944", changeOrigin: true }));
app.use("/explorer", createProxyMiddleware({ target: "http://explorer-api:8000", changeOrigin: true }));

// GraphQL server
const apolloServer = new ApolloServer({ typeDefs, resolvers });
await apolloServer.start();
apolloServer.applyMiddleware({ app, path: "/graphql" });

app.use(errorHandler);

app.listen(4000, () => {
  console.log("🚀 API Gateway running on http://localhost:4000");
});