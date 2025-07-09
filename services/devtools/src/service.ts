let apiKeys: any[] = [];
import { randomBytes } from "crypto";

export async function createApiKey(user: string) {
  const key = randomBytes(32).toString("hex");
  apiKeys.push({ user, key, active: true });
  return { user, key, active: true };
}

export async function revokeApiKey(user: string, key: string) {
  const apiKey = apiKeys.find(k => k.user === user && k.key === key && k.active);
  if (apiKey) apiKey.active = false;
  return { user, key, status: "revoked" };
}

export async function getApiKeys(user: string) {
  return apiKeys.filter(k => k.user === user);
}