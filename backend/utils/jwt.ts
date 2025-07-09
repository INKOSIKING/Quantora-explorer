import jwt from "jsonwebtoken";
import { User } from "../models/user";

const ACCESS_TOKEN_SECRET = process.env.JWT_SECRET || "super-access-secret";
const REFRESH_TOKEN_SECRET = process.env.JWT_REFRESH_SECRET || "super-refresh-secret";
export const ACCESS_TOKEN_LIFETIME = "15m";
export const REFRESH_TOKEN_LIFETIME = "30d";

export function generateAccessToken(user: User) {
  return jwt.sign(
    {
      sub: user.id,
      email: user.email,
      roles: user.roles
    },
    ACCESS_TOKEN_SECRET,
    { expiresIn: ACCESS_TOKEN_LIFETIME }
  );
}

export function generateRefreshToken(user: User) {
  return jwt.sign(
    {
      sub: user.id
    },
    REFRESH_TOKEN_SECRET,
    { expiresIn: REFRESH_TOKEN_LIFETIME }
  );
}

export function verifyAccessToken(token: string): any {
  return jwt.verify(token, ACCESS_TOKEN_SECRET);
}

export function verifyRefreshToken(token: string): any {
  return jwt.verify(token, REFRESH_TOKEN_SECRET);
}