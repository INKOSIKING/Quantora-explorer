import { Router } from "express";
const router = Router();

let users = [
  { id: 1, email: "admin@quantora.com", password: "hashedpassword", role: "admin" },
];

router.post("/register", (req, res) => {
  const user = { ...req.body, id: users.length + 1, role: "customer" };
  users.push(user);
  res.status(201).json(user);
});

router.post("/login", (req, res) => {
  const user = users.find(u => u.email === req.body.email && u.password === req.body.password);
  if (user) res.json({ token: "fake-jwt-token-for-" + user.id, user });
  else res.status(401).json({ error: "Invalid credentials" });
});

export { router as usersRouter };