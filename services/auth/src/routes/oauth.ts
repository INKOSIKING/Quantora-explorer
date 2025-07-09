import { Router } from "express";
import passport from "passport";
import { generateAccessToken, generateRefreshToken } from "../utils/jwt";

const router = Router();

router.get("/google", passport.authenticate("google", { scope: ["profile", "email"] }));

router.get("/google/callback",
  passport.authenticate("google", { session: false, failureRedirect: "/" }),
  (req, res) => {
    const user = (req as any).user;
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    res.redirect(`/auth/success?accessToken=${accessToken}&refreshToken=${refreshToken}`);
  }
);

export { router as oauthRouter };