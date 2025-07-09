import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let cards: Array<{ id: number; userId: number; number: string; expiry: string; status: string }> = [];

// GET all cards
router.get("/", (req, res) => res.json(cards));

// GET one card
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const card = cards.find(c => c.id === Number(req.params.id));
  if (!card) return res.status(404).json({ error: "Card not found" });
  res.json(card);
});

// CREATE card (unique number per user)
router.post("/",
  body("userId").isInt({ min: 1 }),
  body("number").isCreditCard(),
  body("expiry").matches(/^\d{2}\/\d{2}$/),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { userId, number, expiry } = req.body;
    if (cards.some(c => c.userId === userId && c.number === number))
      return res.status(409).json({ error: "Card already exists for this user" });
    const card = { id: cards.length + 1, userId, number, expiry, status: "active" };
    cards.push(card);
    res.status(201).json(card);
  }
);

// UPDATE card status
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["active", "blocked", "expired"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = cards.findIndex(c => c.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Card not found" });
    cards[idx].status = req.body.status;
    res.json(cards[idx]);
  }
);

// DELETE card
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = cards.findIndex(c => c.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Card not found" });
  cards.splice(idx, 1);
  res.status(204).send();
});

export { router as cardsRouter };