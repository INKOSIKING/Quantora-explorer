import { verifyProof } from "snarkjs";
import { readFileSync } from "fs";

export async function verifyZKP(proof: object, publicSignals: string[], verificationKeyPath: string): Promise<boolean> {
  const vKey = JSON.parse(readFileSync(verificationKeyPath, "utf-8"));
  return await verifyProof(vKey, publicSignals, proof);
}

// Usage: Attach to sensitive endpoints (e.g., financial, KYC, etc.)