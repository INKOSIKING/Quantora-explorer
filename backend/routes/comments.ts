import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let comments: Array<{ id: number; postId: number; userId: number; content: string; createdAt: string }> = [];

// GET all comments
router.get("/", (req, res) => res.json(comments));

// GET single comment
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const comment = comments.find(c => c.id === Number(req.params.id));
  if (!comment) return res.status(404).json({ error: "Comment not found" });
  res.json(comment);
});

// CREATE comment
router.post("/",
  body("postId").isInt({ min: 1 }),
  body("userId").isInt({ min: 1 }),
  body("content").isString().isLength({ min: 1, max: 300 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { postId, userId, content } = req.body;
    const comment = {
      id: comments.length + 1,
      postId,
      userId,
      content,
      createdAt: new Date().toISOString()
    };
    comments.push(comment);
    res.status(201).json(comment);
  }
);

// UPDATE comment (content)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("content").isString().isLength({ min: 1, max: 300 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = comments.findIndex(c => c.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Comment not found" });
    comments[idx].content = req.body.content;
    res.json(comments[idx]);
  }
);

// DELETE comment
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = comments.findIndex(c => c.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Comment not found" });
  comments.splice(idx, 1);
  res.status(204).send();
});

export { router as commentsRouter };