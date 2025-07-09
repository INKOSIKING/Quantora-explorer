import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let royalties: Array<{ id: number; nftId: number; recipientId: number; percentage: number }> = [];

// GET all royalties
router.get("/", (req, res) => res.json(royalties));

// GET single royalty
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const royalty = royalties.find(r => r.id === Number(req.params.id));
  if (!royalty) return res.status(404).json({ error: "Royalty not found" });
  res.json(royalty);
});

// CREATE royalty (unique per nft+recipient)
router.post("/",
  body("nftId").isInt({ min: 1 }),
  body("recipientId").isInt({ min: 1 }),
  body("percentage").isFloat({ gt: 0, lt: 100 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { nftId, recipientId } = req.body;
    if (royalties.some(r => r.nftId === nftId && r.recipientId === recipientId))
      return res.status(409).json({ error: "Royalty already set for this NFT and recipient" });
    const royalty = { id: royalties.length + 1, ...req.body };
    royalties.push(royalty);
    res.status(201).json(royalty);
  }
);

// UPDATE royalty (percentage)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("percentage").isFloat({ gt: 0, lt: 100 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = royalties.findIndex(r => r.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Royalty not found" });
    royalties[idx].percentage = req.body.percentage;
    res.json(royalties[idx]);
  }
);

// DELETE royalty
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = royalties.findIndex(r => r.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Royalty not found" });
  royalties.splice(idx, 1);
  res.status(204).send();
});

export { router as royaltiesRouter };