import jwt from "jsonwebtoken";
import axios from "axios";

// For apps/services: verify JWT (using public key if using RS256)
// You could fetch JWKS/public key from auth service in real prod
export function verifyJwt(token: string, secret: string): any {
  return jwt.verify(token, secret);
}

// For apps: login/register/refresh helpers
export async function login(email: string, password: string) {
  return axios.post("/auth/login", { email, password });
}

export async function register(email: string, password: string, name: string) {
  return axios.post("/auth/register", { email, password, name });
}

// Add more helpers as needed...