import { Client } from "pg";
import { subscribeToChainBlocks } from "./chainClient";
import { processBlock } from "./processors";

const db = new Client({ connectionString: process.env.PG_CONN });
db.connect();

subscribeToChainBlocks(async (block) => {
  try {
    await processBlock(block, db);
    console.log(`Indexed block: ${block.number}`);
  } catch (err) {
    console.error("Indexer error:", err);
  }
});