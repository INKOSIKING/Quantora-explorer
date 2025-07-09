import { Request, Response, NextFunction } from "express";
import rateLimit from "express-rate-limit";

// Auth middleware example (JWT, OAuth, API Key, etc.)
export function authMiddleware(req: Request, res: Response, next: NextFunction) {
  // Example: check Authorization header or cookie for token
  // Implement robust auth logic (JWT verify, session, etc.)
  next();
}

// Centralized error handler
export function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  console.error(err);
  res.status(500).json({ error: err.message });
}

// Rate limiter
export const rateLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100,
  message: "Rate limit exceeded"
});