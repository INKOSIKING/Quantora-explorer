import { Router } from "express";
import { body, param, validationResult } from "express-validator";
const router = Router();

let documents: Array<{ id: number; applicationId: number; title: string; url: string; status: string; uploadedAt: string }> = [];

// GET all documents
router.get("/", (req, res) => res.json(documents));

// GET single document
router.get("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const doc = documents.find(d => d.id === Number(req.params.id));
  if (!doc) return res.status(404).json({ error: "Document not found" });
  res.json(doc);
});

// CREATE document (one pending per application/title)
router.post("/",
  body("applicationId").isInt({ min: 1 }),
  body("title").isString().isLength({ min: 2 }),
  body("url").isString().isURL(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const { applicationId, title } = req.body;
    if (documents.some(d => d.applicationId === applicationId && d.title === title && d.status === "pending"))
      return res.status(409).json({ error: "Pending document with this title already exists for this application" });
    const doc = {
      id: documents.length + 1,
      ...req.body,
      status: "pending",
      uploadedAt: new Date().toISOString()
    };
    documents.push(doc);
    res.status(201).json(doc);
  }
);

// UPDATE document (status or url)
router.put("/:id",
  param("id").isInt({ min: 1 }),
  body("status").optional().isIn(["pending", "approved", "rejected"]),
  body("url").optional().isString().isURL(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
    const idx = documents.findIndex(d => d.id === Number(req.params.id));
    if (idx === -1) return res.status(404).json({ error: "Document not found" });
    documents[idx] = { ...documents[idx], ...req.body };
    res.json(documents[idx]);
  }
);

// DELETE document
router.delete("/:id", param("id").isInt({ min: 1 }), (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  const idx = documents.findIndex(d => d.id === Number(req.params.id));
  if (idx === -1) return res.status(404).json({ error: "Document not found" });
  documents.splice(idx, 1);
  res.status(204).send();
});

export { router as documentsRouter };