import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let friendships: Array<{ id: number; requesterId: number; addresseeId: number; status: string; createdAt: string }> = [];

// GET all friendships
router.get("/", (req, res) => res.json(friendships));

// GET single friendship
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const friendship = friendships.find(f => f.id === Number(req.params.id));
  if (!friendship) return res.status(404).json({ error: "Friendship not found" });
  res.json(friendship);
});

// CREATE friendship (pending request, unique per user pair)
router.post("/",
  body("requesterId").isInt({ min: 1 }),
  body("addresseeId").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { requesterId, addresseeId } = req.body;
    if (requesterId === addresseeId)
      return res.status(400).json({ error: "Cannot friend yourself" });
    if (friendships.some(f =>
      ((f.requesterId === requesterId && f.addresseeId === addresseeId) ||
       (f.requesterId === addresseeId && f.addresseeId === requesterId))
    ))
      return res.status(409).json({ error: "Friendship or request already exists between these users" });
    const friendship = {
      id: friendships.length + 1,
      requesterId,
      addresseeId,
      status: "pending",
      createdAt: new Date().toISOString()
    };
    friendships.push(friendship);
    res.status(201).json(friendship);
  }
);

// UPDATE friendship (status: pending/accepted/rejected/blocked)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["pending", "accepted", "rejected", "blocked"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = friendships.findIndex(f => f.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Friendship not found" });
    friendships[idx].status = req.body.status;
    res.json(friendships[idx]);
  }
);

// DELETE friendship
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = friendships.findIndex(f => f.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Friendship not found" });
  friendships.splice(idx, 1);
  res.status(204).send();
});

export { router as friendshipsRouter };