import { Router } from "express";
import { authenticateJWT, requireRoles } from "../middleware/auth";
import { users, findUserById } from "../models/user";
import { body, param, validationResult } from "express-validator";

const router = Router();

router.get("/me", authenticateJWT, (req, res) => {
  const user = (req as any).user;
  res.json({ id: user.id, email: user.email, name: user.name, roles: user.roles });
});

router.put("/me", authenticateJWT,
  body("name").optional().isString().isLength({ min: 2 }),
  (req, res) => {
    const user = (req as any).user;
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    if (req.body.name) user.name = req.body.name;
    user.updatedAt = new Date().toISOString();
    res.json({ id: user.id, email: user.email, name: user.name, roles: user.roles });
  }
);

router.get("/", authenticateJWT, requireRoles("admin"), (req, res) => {
  res.json(users.map(u => ({ id: u.id, email: u.email, name: u.name, roles: u.roles })));
});

router.put("/:id/roles", authenticateJWT, requireRoles("admin"),
  param("id").isInt({ min: 1 }),
  body("roles").isArray(),
  (req, res) => {
    const { id } = req.params;
    const user = findUserById(Number(id));
    if (!user) return res.status(404).json({ error: "User not found" });
    user.roles = req.body.roles;
    user.updatedAt = new Date().toISOString();
    res.json({ id: user.id, email: user.email, name: user.name, roles: user.roles });
  }
);

export { router as usersRouter };