import { Router } from "express";
import { body, validationResult } from "express-validator";
import crypto from "crypto";
import { users, findUserByEmail } from "../models/user";
import bcrypt from "bcrypt";

const resetTokens: Record<string, { email: string; expires: number }> = {};
const router = Router();

router.post("/request",
  body("email").isEmail(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { email } = req.body;
    const user = findUserByEmail(email);
    if (!user) return res.status(200).json({ success: true }); // Don't reveal user
    const token = crypto.randomBytes(32).toString("hex");
    resetTokens[token] = { email, expires: Date.now() + 1000 * 60 * 30 };
    res.json({ success: true, token }); // REMOVE token in prod, only send via email
  }
);

router.post("/reset",
  body("token").isString(),
  body("password").isLength({ min: 8 }),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { token, password } = req.body;
    const data = resetTokens[token];
    if (!data || data.expires < Date.now()) return res.status(400).json({ error: "Invalid or expired token" });
    const user = findUserByEmail(data.email);
    if (!user) return res.status(400).json({ error: "User not found" });
    user.passwordHash = await bcrypt.hash(password, 12);
    user.updatedAt = new Date().toISOString();
    delete resetTokens[token];
    res.json({ success: true });
  }
);

export { router as passwordResetRouter };