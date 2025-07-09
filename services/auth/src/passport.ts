import passport from "passport";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";
import { users, createUser, findUserByEmail } from "./models/user";
import crypto from "crypto";

passport.use(new GoogleStrategy({
  clientID: process.env.GOOGLE_CLIENT_ID!,
  clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
  callbackURL: "/oauth/google/callback",
}, async (accessToken, refreshToken, profile, done) => {
  let user = findUserByEmail(profile.emails?.[0].value!);
  if (!user) {
    user = await createUser(profile.emails?.[0].value!, crypto.randomBytes(16).toString("hex"), profile.displayName ?? "Google User");
  }
  return done(null, user);
}));

passport.serializeUser((user: any, done) => done(null, user.id));
passport.deserializeUser((id: number, done) => {
  const user = users.find(u => u.id === id);
  done(null, user!);
});