import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();
let nfts = [];
router.get("/", (req, res) => res.json(nfts));
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const item = nfts.find(x => x.id === Number(req.params.id));
  if (!item) return res.status(404).json({ error: "NFT not found" });
  res.json(item);
});
router.post("/", body("uri").isString().isLength({ min: 5 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const { uri } = req.body;
  const nft = { id: nfts.length + 1, uri, createdAt: new Date().toISOString() };
  nfts.push(nft);
  res.status(201).json(nft);
});
// UPDATE/DELETE as above...
export { router as nftsRouter };