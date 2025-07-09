import { Router } from "express";
import bcrypt from "bcryptjs";
const router = Router();
let users = [];
router.post("/register", (req, res) => {
  const hashed = bcrypt.hashSync(req.body.password, 10);
  const user = { ...req.body, password: hashed, id: users.length + 1, kyc: false };
  users.push(user);
  res.status(201).json(user);
});
router.post("/login", (req, res) => {
  const user = users.find(u => u.email === req.body.email);
  if (user && bcrypt.compareSync(req.body.password, user.password))
    res.json({ token: "jwt-" + user.id, user });
  else res.status(401).json({ error: "Invalid credentials" });
});
export { router as usersRouter };