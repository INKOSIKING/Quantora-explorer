import jwksRsa from "jwks-rsa";
import jwt from "jsonwebtoken";

const jwksClient = jwksRsa({
  jwksUri: process.env.JWKS_URI!,
  cache: true,
  rateLimit: true,
});

export async function validateToken(token: string, requiredScope: string) {
  const decoded: any = jwt.decode(token, { complete: true });
  const kid = decoded.header.kid;

  const key = await jwksClient.getSigningKey(kid);
  const signingKey = key.getPublicKey();

  const payload: any = jwt.verify(token, signingKey, { audience: process.env.AUDIENCE, issuer: process.env.ISSUER });
  if (!payload.scope.split(" ").includes(requiredScope)) {
    throw new Error("Insufficient scope");
  }
  return payload;
}