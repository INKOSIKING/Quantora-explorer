import React, { useState } from "react";
import { Box, TextField, Button, Alert, Typography } from "@mui/material";
import axios from "axios";
export default function DAOCreator() {
  const [form, setForm] = useState({
    name: "", founders: "", voting_type: "Simple", quorum: "50", proposal_duration: "86400", token_address: "",
    owner: "",
  });
  const [result, setResult] = useState<any>(null);
  const MIN_FEE = 0.000001;
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    setForm({ ...form, [e.target.name]: e.target.value });
  const handleSubmit = async () => {
    try {
      const data = await axios.post("/api/creator/dao", {
        user: form.owner,
        ...form,
        founders: form.founders.split(","),
      });
      setResult({ ok: true, ...data.data });
    } catch (e: any) {
      setResult({ ok: false, error: e.message });
    }
  };
  return (
    <Box>
      <TextField label="DAO Name" name="name" value={form.name} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Founders (comma-separated)" name="founders" value={form.founders} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Voting Type" name="voting_type" value={form.voting_type} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Quorum (%)" name="quorum" value={form.quorum} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Proposal Duration (sec)" name="proposal_duration" value={form.proposal_duration} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Token Address (optional)" name="token_address" value={form.token_address} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Owner Address" name="owner" value={form.owner} onChange={handleChange} fullWidth margin="dense" />
      <Typography color="secondary" sx={{ mt: 1 }}>
        Network fee: {MIN_FEE} ETH (required, sent to maintainer)
      </Typography>
      <Button variant="contained" sx={{ mt: 2 }} onClick={handleSubmit}>Create DAO</Button>
      {result && (
        <Alert severity={result.ok ? "success" : "error"} sx={{ mt: 2 }}>
          {result.ok ? `DAO deployed: ${result.contract_address}` : result.error}
        </Alert>
      )}
    </Box>
  );
}