import { Router } from "express";
const router = Router();
let kycRequests = [];
router.post("/submit", (req, res) => {
  const kyc = { ...req.body, id: kycRequests.length + 1, status: "pending" };
  kycRequests.push(kyc);
  res.status(201).json(kyc);
});
router.get("/", (req, res) => res.json(kycRequests));
export { router as kycRouter };