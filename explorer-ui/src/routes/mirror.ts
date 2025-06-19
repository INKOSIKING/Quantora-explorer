import { Router, Request, Response } from "express";
import axios from "axios";

const router = Router();

router.get("/mirror/:type/:id", async (req: Request, res: Response) => {
  const { type, id } = req.params;
  let url;
  if (type === "tx") url = `https://etherscan.io/tx/${id}`;
  else if (type === "address") url = `https://etherscan.io/address/${id}`;
  else return res.status(400).json({ error: "Unknown type" });
  try {
    const { data } = await axios.get(url);
    res.type("html").send(data);
  } catch {
    res.status(502).json({ error: "Mirror failed" });
  }
});
export default router;