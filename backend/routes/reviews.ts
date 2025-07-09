import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let reviews: Array<{ id: number; itemId: number; userId: number; rating: number; comment: string; createdAt: string }> = [];

// GET all reviews
router.get("/", (req, res) => res.json(reviews));

// GET single review
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const review = reviews.find(r => r.id === Number(req.params.id));
  if (!review) return res.status(404).json({ error: "Review not found" });
  res.json(review);
});

// CREATE review (one per user/item)
router.post("/",
  body("itemId").isInt({ min: 1 }),
  body("userId").isInt({ min: 1 }),
  body("rating").isInt({ min: 1, max: 5 }),
  body("comment").optional().isString(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { itemId, userId } = req.body;
    if (reviews.some(r => r.itemId === itemId && r.userId === userId))
      return res.status(409).json({ error: "User has already reviewed this item" });
    const review = {
      id: reviews.length + 1,
      ...req.body,
      createdAt: new Date().toISOString()
    };
    reviews.push(review);
    res.status(201).json(review);
  }
);

// UPDATE review (rating, comment)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("rating").optional().isInt({ min: 1, max: 5 }),
  body("comment").optional().isString(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = reviews.findIndex(r => r.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Review not found" });
    reviews[idx] = { ...reviews[idx], ...req.body };
    res.json(reviews[idx]);
  }
);

// DELETE review
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = reviews.findIndex(r => r.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Review not found" });
  reviews.splice(idx, 1);
  res.status(204).send();
});

export { router as reviewsRouter };