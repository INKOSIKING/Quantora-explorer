import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let bids: Array<{ id: number; listingId: number; bidderId: number; amount: number; status: string; createdAt: string }> = [];

// GET all bids
router.get("/", (req, res) => res.json(bids));

// GET single bid
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const bid = bids.find(b => b.id === Number(req.params.id));
  if (!bid) return res.status(404).json({ error: "Bid not found" });
  res.json(bid);
});

// CREATE bid (on active listing)
router.post("/",
  body("listingId").isInt({ min: 1 }),
  body("bidderId").isInt({ min: 1 }),
  body("amount").isFloat({ gt: 0 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    // In real app: check that listing is active, etc.
    const { listingId, amount } = req.body;
    // Only allow higher bids on the same listing
    const maxBid = Math.max(0, ...bids.filter(b => b.listingId === listingId).map(b => b.amount));
    if (amount <= maxBid)
      return res.status(400).json({ error: "Bid must be higher than current highest bid" });
    const bid = {
      id: bids.length + 1,
      ...req.body,
      status: "open",
      createdAt: new Date().toISOString()
    };
    bids.push(bid);
    res.status(201).json(bid);
  }
);

// UPDATE bid (status: open, accepted, rejected)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["open", "accepted", "rejected"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = bids.findIndex(b => b.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Bid not found" });
    bids[idx].status = req.body.status;
    res.json(bids[idx]);
  }
);

// DELETE bid
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = bids.findIndex(b => b.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Bid not found" });
  bids.splice(idx, 1);
  res.status(204).send();
});

export { router as bidsRouter };