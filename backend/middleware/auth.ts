import { Request, Response, NextFunction } from "express";
import { findUserById } from "../models/user";
import { verifyAccessToken } from "../utils/jwt";

export function authenticateJWT(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(401).json({ error: "No token provided" });
  const token = authHeader.split(" ")[1];
  try {
    const payload = verifyAccessToken(token);
    const user = findUserById(Number(payload.sub));
    if (!user) return res.status(401).json({ error: "User not found" });
    (req as any).user = user;
    next();
  } catch (err) {
    return res.status(401).json({ error: "Invalid or expired token" });
  }
}

export function requireRoles(...roles: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    const user = (req as any).user;
    if (!user) return res.status(401).json({ error: "Not authenticated" });
    if (!user.roles.some((r: string) => roles.includes(r)))
      return res.status(403).json({ error: "Forbidden: insufficient role" });
    next();
  };
}