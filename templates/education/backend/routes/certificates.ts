import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let certificates: Array<{ id: number; enrollmentId: number; issuedAt: string }> = [];

// GET all certificates
router.get("/", (req, res) => res.json(certificates));

// GET single certificate
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const cert = certificates.find(c => c.id === Number(req.params.id));
  if (!cert) return res.status(404).json({ error: "Certificate not found" });
  res.json(cert);
});

// CREATE certificate (prevent duplicate issuance)
router.post("/",
  body("enrollmentId").isInt({ min: 1 }),
  (req, res) => {
    const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { enrollmentId } = req.body;
    if (certificates.some(c => c.enrollmentId === enrollmentId))
      return res.status(409).json({ error: "Certificate already issued for this enrollment" });
    const cert = { id: certificates.length + 1, enrollmentId, issuedAt: new Date().toISOString() };
    certificates.push(cert);
    res.status(201).json(cert);
  }
);

// UPDATE certificate (can't change enrollmentId)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("issuedAt").isISO8601(),
  (req, res) => {
    const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = certificates.findIndex(c => c.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Certificate not found" });
    certificates[idx].issuedAt = req.body.issuedAt;
    res.json(certificates[idx]);
  }
);

// DELETE certificate
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req); if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = certificates.findIndex(c => c.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Certificate not found" });
  certificates.splice(idx, 1);
  res.status(204).send();
});

export { router as certificatesRouter };