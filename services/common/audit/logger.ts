import { Request, Response, NextFunction } from "express";
import { v4 as uuidv4 } from "uuid";

export function auditLogger(req: Request, res: Response, next: NextFunction) {
  const user = (req as any).user || {};
  const traceId = req.headers["x-trace-id"] || uuidv4();

  const log = {
    timestamp: new Date().toISOString(),
    traceId,
    userId: user.id || "anonymous",
    method: req.method,
    path: req.originalUrl,
    status: res.statusCode,
    ip: req.ip,
    userAgent: req.headers["user-agent"],
    action: "API_REQUEST"
  };

  // Replace with your log shipper or SIEM integration
  console.log(JSON.stringify(log));
  next();
}