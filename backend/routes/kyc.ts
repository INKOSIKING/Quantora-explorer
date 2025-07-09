import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let kycRecords: Array<{ id: number; userId: number; status: string; document: string; reviewedAt?: string }> = [];

// GET all KYC records
router.get("/", (req, res) => res.json(kycRecords));

// GET one KYC record
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const record = kycRecords.find(k => k.id === Number(req.params.id));
  if (!record) return res.status(404).json({ error: "KYC record not found" });
  res.json(record);
});

// CREATE KYC record (one per user)
router.post("/",
  body("userId").isInt({ min: 1 }),
  body("document").isString().isLength({ min: 5 }),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { userId, document } = req.body;
    if (kycRecords.some(k => k.userId === userId))
      return res.status(409).json({ error: "KYC already submitted for this user" });
    const record = { id: kycRecords.length + 1, userId, status: "pending", document };
    kycRecords.push(record);
    res.status(201).json(record);
  }
);

// UPDATE KYC record status
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").isIn(["pending", "approved", "rejected"]),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = kycRecords.findIndex(k => k.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "KYC record not found" });
    kycRecords[idx].status = req.body.status;
    kycRecords[idx].reviewedAt = new Date().toISOString();
    res.json(kycRecords[idx]);
  }
);

// DELETE KYC record
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = kycRecords.findIndex(k => k.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "KYC record not found" });
  kycRecords.splice(idx, 1);
  res.status(204).send();
});

export { router as kycRouter };