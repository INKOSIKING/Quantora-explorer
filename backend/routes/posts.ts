import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let posts: Array<{ id: number; userId: number; content: string; createdAt: string; status: string }> = [];

// GET all posts
router.get("/", (req, res) => res.json(posts));

// GET single post
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const post = posts.find(p => p.id === Number(req.params.id));
  if (!post) return res.status(404).json({ error: "Post not found" });
  res.json(post);
});

// CREATE post
router.post("/",
  body("userId").isInt({ min: 1 }),
  body("content").isString().isLength({ min: 1, max: 500 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { userId, content } = req.body;
    const post = {
      id: posts.length + 1,
      userId,
      content,
      createdAt: new Date().toISOString(),
      status: "active"
    };
    posts.push(post);
    res.status(201).json(post);
  }
);

// UPDATE post (content or status)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("content").optional().isString().isLength({ min: 1, max: 500 }),
  body("status").optional().isIn(["active", "deleted", "archived"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = posts.findIndex(p => p.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Post not found" });
    posts[idx] = { ...posts[idx], ...req.body };
    res.json(posts[idx]);
  }
);

// DELETE post
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = posts.findIndex(p => p.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Post not found" });
  posts.splice(idx, 1);
  res.status(204).send();
});

export { router as postsRouter };