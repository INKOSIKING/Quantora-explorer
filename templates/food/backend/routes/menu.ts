import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();
let menu = [];
router.get("/", (req, res) => res.json(menu));
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const item = menu.find(x => x.id === Number(req.params.id));
  if (!item) return res.status(404).json({ error: "Menu item not found" });
  res.json(item);
});
router.post("/", body("name").isString(), body("price").isFloat({ gt: 0 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const { name, price } = req.body;
  const item = { id: menu.length + 1, name, price, createdAt: new Date().toISOString() };
  menu.push(item);
  res.status(201).json(item);
});
// UPDATE/DELETE as above...
export { router as menuRouter };