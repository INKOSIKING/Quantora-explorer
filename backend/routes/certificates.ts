import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let certificates: Array<{ id: number; enrollmentId: number; issuedAt: string; url: string }> = [];

// GET all certificates
router.get("/", (req, res) => res.json(certificates));

// GET single certificate
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const cert = certificates.find(c => c.id === Number(req.params.id));
  if (!cert) return res.status(404).json({ error: "Certificate not found" });
  res.json(cert);
});

// CREATE certificate (one per enrollment)
router.post("/",
  body("enrollmentId").isInt({ min: 1 }),
  body("url").isString().isURL(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { enrollmentId, url } = req.body;
    if (certificates.some(c => c.enrollmentId === enrollmentId))
      return res.status(409).json({ error: "Certificate already issued for this enrollment" });
    const cert = {
      id: certificates.length + 1,
      enrollmentId,
      issuedAt: new Date().toISOString(),
      url
    };
    certificates.push(cert);
    res.status(201).json(cert);
  }
);

// UPDATE certificate (url only)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("url").isString().isURL(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = certificates.findIndex(c => c.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Certificate not found" });
    certificates[idx].url = req.body.url;
    res.json(certificates[idx]);
  }
);

// DELETE certificate
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = certificates.findIndex(c => c.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Certificate not found" });
  certificates.splice(idx, 1);
  res.status(204).send();
});

export { router as certificatesRouter };