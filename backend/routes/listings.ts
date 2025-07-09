import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let listings: Array<{ id: number; nftId: number; sellerId: number; price: number; status: string; createdAt: string }> = [];

// GET all listings
router.get("/", (req, res) => res.json(listings));

// GET single listing
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const listing = listings.find(l => l.id === Number(req.params.id));
  if (!listing) return res.status(404).json({ error: "Listing not found" });
  res.json(listing);
});

// CREATE listing (unique active listing per nft)
router.post("/",
  body("nftId").isInt({ min: 1 }),
  body("sellerId").isInt({ min: 1 }),
  body("price").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { nftId } = req.body;
    if (listings.some(l => l.nftId === nftId && l.status === "active"))
      return res.status(409).json({ error: "NFT already listed" });
    const listing = {
      id: listings.length + 1,
      ...req.body,
      status: "active",
      createdAt: new Date().toISOString()
    };
    listings.push(listing);
    res.status(201).json(listing);
  }
);

// UPDATE listing (price or status)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("price").optional().isFloat({ gt: 0 }),
  body("status").optional().isIn(["active", "sold", "canceled"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = listings.findIndex(l => l.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Listing not found" });
    // Only one active listing per NFT
    if (
      req.body.status === "active" &&
      listings.some(l => l.nftId === listings[idx].nftId && l.status === "active" && l.id !== Number(req.params.id))
    )
      return res.status(409).json({ error: "NFT already has an active listing" });
    listings[idx] = { ...listings[idx], ...req.body };
    res.json(listings[idx]);
  }
);

// DELETE listing
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = listings.findIndex(l => l.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Listing not found" });
  listings.splice(idx, 1);
  res.status(204).send();
});

export { router as listingsRouter };