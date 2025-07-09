import { Router } from "express";
import { body, validationResult } from "express-validator";
import bcrypt from "bcrypt";
import { createUser, findUserByEmail, findUserById } from "../models/user";
import { generateAccessToken, generateRefreshToken, verifyRefreshToken } from "../utils/jwt";
import { authenticateJWT } from "../middleware/auth";

const router = Router();
const refreshTokens: { [token: string]: number } = {};

// Register
router.post("/register",
  body("email").isEmail(),
  body("password").isLength({ min: 8 }),
  body("name").isString().isLength({ min: 2 }),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { email, password, name } = req.body;
    try {
      const user = await createUser(email, password, name);
      res.status(201).json({ id: user.id, email: user.email, name: user.name, roles: user.roles });
    } catch (err) {
      res.status(409).json({ error: (err as Error).message });
    }
  }
);

// Login
router.post("/login",
  body("email").isEmail(),
  body("password").isString(),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { email, password } = req.body;
    const user = findUserByEmail(email);
    if (!user) return res.status(401).json({ error: "Invalid credentials" });
    const match = await bcrypt.compare(password, user.passwordHash);
    if (!match) return res.status(401).json({ error: "Invalid credentials" });
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    refreshTokens[refreshToken] = user.id;
    res.json({ accessToken, refreshToken });
  }
);

// Refresh token
router.post("/refresh", body("refreshToken").isString(), (req, res) => {
  const { refreshToken } = req.body;
  try {
    const payload = verifyRefreshToken(refreshToken);
    if (!refreshTokens[refreshToken] || refreshTokens[refreshToken] !== payload.sub)
      return res.status(401).json({ error: "Invalid refresh token" });
    const user = findUserById(Number(payload.sub));
    if (!user) return res.status(401).json({ error: "User not found" });
    const accessToken = generateAccessToken(user);
    res.json({ accessToken });
  } catch (err) {
    return res.status(401).json({ error: "Invalid or expired refresh token" });
  }
});

// Logout
router.post("/logout", body("refreshToken").isString(), (req, res) => {
  const { refreshToken } = req.body;
  delete refreshTokens[refreshToken];
  res.json({ success: true });
});

// Whoami
router.get("/me", authenticateJWT, (req, res) => {
  const user = (req as any).user;
  res.json({ id: user.id, email: user.email, name: user.name, roles: user.roles });
});

export { router as authRouter };