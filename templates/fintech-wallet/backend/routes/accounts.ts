import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();
let accounts = [];

// GET all
router.get("/", (req, res) => res.json(accounts));

// GET one
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const account = accounts.find(a => a.id === Number(req.params.id));
  if (!account) return res.status(404).json({ error: "Account not found" });
  res.json(account);
});

// CREATE
router.post("/",
  body("name").isString().isLength({ min: 2 }),
  body("type").isIn(["checking", "savings"]),
  (req, res) => {
    const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { name, type } = req.body;
    const account = { id: accounts.length + 1, name, type, balance: 0, createdAt: new Date().toISOString() };
    accounts.push(account);
    res.status(201).json(account);
  }
);

// UPDATE/DELETE as above...

export { router as accountsRouter };