import { db } from "../db";

export async function getBranding(domain: string) {
  const r = await db.query("SELECT branding FROM tenants WHERE domain = $1", [domain]);
  return r.rows[0]?.branding || { theme: "default", logo: "/logo.png" };
}

export async function setBranding(domain: string, branding: any) {
  await db.query("UPDATE tenants SET branding = $2 WHERE domain = $1", [domain, branding]);
}