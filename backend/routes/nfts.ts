import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let nfts: Array<{ id: number; ownerId: number; tokenId: string; metadata: any; createdAt: string }> = [];

// GET all NFTs
router.get("/", (req, res) => res.json(nfts));

// GET single NFT
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const nft = nfts.find(n => n.id === Number(req.params.id));
  if (!nft) return res.status(404).json({ error: "NFT not found" });
  res.json(nft);
});

// CREATE NFT (unique tokenId)
router.post("/",
  body("ownerId").isInt({ min: 1 }),
  body("tokenId").isString().isLength({ min: 2 }),
  body("metadata").exists(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { ownerId, tokenId, metadata } = req.body;
    if (nfts.some(n => n.tokenId === tokenId))
      return res.status(409).json({ error: "Token ID already exists" });
    const nft = { id: nfts.length + 1, ownerId, tokenId, metadata, createdAt: new Date().toISOString() };
    nfts.push(nft);
    res.status(201).json(nft);
  }
);

// UPDATE NFT (only metadata allowed)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("metadata").exists(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = nfts.findIndex(n => n.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "NFT not found" });
    nfts[idx].metadata = req.body.metadata;
    res.json(nfts[idx]);
  }
);

// DELETE NFT
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = nfts.findIndex(n => n.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "NFT not found" });
  nfts.splice(idx, 1);
  res.status(204).send();
});

export { router as nftsRouter };