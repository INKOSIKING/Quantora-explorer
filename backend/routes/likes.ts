import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let likes: Array<{ id: number; postId: number; userId: number; createdAt: string }> = [];

// GET all likes
router.get("/", (req, res) => res.json(likes));

// GET single like
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const like = likes.find(l => l.id === Number(req.params.id));
  if (!like) return res.status(404).json({ error: "Like not found" });
  res.json(like);
});

// CREATE like (one per user/post)
router.post("/",
  body("postId").isInt({ min: 1 }),
  body("userId").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { postId, userId } = req.body;
    if (likes.some(l => l.postId === postId && l.userId === userId))
      return res.status(409).json({ error: "User already liked this post" });
    const like = {
      id: likes.length + 1,
      postId,
      userId,
      createdAt: new Date().toISOString()
    };
    likes.push(like);
    res.status(201).json(like);
  }
);

// DELETE like
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = likes.findIndex(l => l.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Like not found" });
  likes.splice(idx, 1);
  res.status(204).send();
});

export { router as likesRouter };