import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
const SECRET = process.env.JWT_SECRET || "devsecret";
export function authMiddleware(req: Request, res: Response, next: NextFunction) {
  const auth = req.headers["authorization"];
  if (!auth || !auth.startsWith("Bearer ")) return res.status(401).json({error: "Unauthorized"});
  try {
    (req as any).user = jwt.verify(auth.slice(7), SECRET);
    next();
  } catch (e) {
    res.status(401).json({error: "Invalid token"});
  }
}
export function adminMiddleware(req: Request, res: Response, next: NextFunction) {
  if ((req as any).user?.role !== "admin") return res.status(403).json({error: "Forbidden"});
  next();
}