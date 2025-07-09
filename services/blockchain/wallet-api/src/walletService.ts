import { mnemonicGenerate, cryptoWaitReady } from "@polkadot/util-crypto";
import { Keyring } from "@polkadot/keyring";

export async function createWallet(userId: string, type: "custodial" | "non-custodial") {
  await cryptoWaitReady();
  const keyring = new Keyring({ type: "sr25519" });
  const mnemonic = mnemonicGenerate();
  const pair = keyring.addFromUri(mnemonic);

  // Store securely if custodial, else return mnemonic
  return { address: pair.address, ...(type === "non-custodial" ? { mnemonic } : {}) };
}

export async function getBalance(address: string) {
  // Connect to Quantora Chain RPC and fetch balance
  return "1000000 QTX";
}

export async function sendTx(from: string, to: string, amount: number) {
  // Build, sign, and submit transaction to chain node
  return { txHash: "0xabc...", status: "pending" };
}