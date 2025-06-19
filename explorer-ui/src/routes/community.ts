import { Router } from "express";
import { addComment, getComments } from "../community/comments";
import { submitBug } from "../community/bug_reports";
import { setVerified, isVerified } from "../contracts/verified";

const router = Router();

router.post("/comment", async (req, res) => {
  const { target, body } = req.body;
  await addComment(req.user.id, target, body);
  res.status(201).end();
});
router.get("/comments/:target", async (req, res) => {
  const data = await getComments(req.params.target);
  res.json(data.rows);
});

router.post("/bug", async (req, res) => {
  const { detail, page } = req.body;
  await submitBug(req.user.id, detail, page);
  res.status(201).end();
});

router.post("/contract/verify", async (req, res) => {
  await setVerified(req.body.address, true);
  res.status(200).end();
});
router.get("/contract/verified/:address", async (req, res) => {
  res.json({ verified: await isVerified(req.params.address) });
});

export default router;