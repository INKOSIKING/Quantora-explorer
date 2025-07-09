import { Router } from "express";
const router = Router();

router.post("/", (req, res) => {
  // Integrate with QTX chain & payment provider here
  res.json({ status: "success", txHash: "0x123qtx" });
});

export { router as paymentsRouter };