import express from "express";
import { createProfile, follow, unfollow } from "./service";

const app = express();
app.use(express.json());

app.post("/profile", async (req, res) => {
  const { address, displayName } = req.body;
  const profile = await createProfile(address, displayName);
  res.json(profile);
});

app.post("/follow", async (req, res) => {
  const { follower, followee } = req.body;
  await follow(follower, followee);
  res.json({ status: "following" });
});

app.post("/unfollow", async (req, res) => {
  const { follower, followee } = req.body;
  await unfollow(follower, followee);
  res.json({ status: "unfollowed" });
});

app.listen(4600, () => console.log("Social Service running on :4600"));