import bcrypt from "bcrypt";

export type Role = "user" | "admin" | "moderator" | "seller" | "doctor";

export interface User {
  id: number;
  email: string;
  passwordHash: string;
  roles: Role[];
  name: string;
  createdAt: string;
  updatedAt: string;
}

// In-memory user store (replace with DB in prod)
export const users: User[] = [];

export async function createUser(email: string, password: string, name: string, roles: Role[] = ["user"]): Promise<User> {
  if (users.some(u => u.email === email)) throw new Error("Email already registered");
  const passwordHash = await bcrypt.hash(password, 12);
  const user: User = {
    id: users.length + 1,
    email,
    passwordHash,
    roles,
    name,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };
  users.push(user);
  return user;
}

export function findUserByEmail(email: string): User | undefined {
  return users.find(u => u.email === email);
}

export function findUserById(id: number): User | undefined {
  return users.find(u => u.id === id);
}