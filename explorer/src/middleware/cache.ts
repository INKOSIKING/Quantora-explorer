import { Request, Response, NextFunction } from "express";
import redis from "../cache/redis";

export async function cacheMiddleware(req: Request, res: Response, next: NextFunction) {
  const key = `cache:${req.originalUrl}`;
  const cached = await redis.get(key);
  if (cached) {
    res.set("X-Cache", "HIT");
    res.type("json").send(cached);
    return;
  }
  const send = res.send.bind(res);
  res.send = (body) => {
    redis.setex(key, 30, body); // cache for 30 seconds
    return send(body);
  };
  next();
}