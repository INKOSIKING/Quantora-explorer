import { ApiPromise, WsProvider } from "@polkadot/api";

export async function subscribeToChainBlocks(callback: (block: any) => Promise<void>) {
  const wsProvider = new WsProvider("ws://quantora-chain:9944");
  const api = await ApiPromise.create({ provider: wsProvider });

  api.rpc.chain.subscribeNewHeads(async (header) => {
    const block = await api.rpc.chain.getBlock(header.hash);
    await callback({ number: header.number.toNumber(), ...block });
  });
}