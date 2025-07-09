import { Router } from "express";
const router = Router();
let listings = [];
router.post("/list", (req, res) => {
  const listing = { ...req.body, id: listings.length + 1, status: "active" };
  listings.push(listing);
  res.status(201).json(listing);
});
router.post("/buy/:id", (req, res) => {
  const idx = listings.findIndex(l => l.id === Number(req.params.id));
  if (idx > -1 && listings[idx].status === "active") {
    listings[idx].status = "sold";
    res.json(listings[idx]);
  } else res.status(404).json({ error: "Not found or already sold" });
});
router.get("/", (req, res) => res.json(listings));
export { router as marketplaceRouter };