import React, { useState } from "react";
import { Box, TextField, Button, Alert, Typography } from "@mui/material";
import axios from "axios";

export default function Send() {
  const [to, setTo] = useState("");
  const [amount, setAmount] = useState("");
  const [result, setResult] = useState<any>(null);
  const MIN_FEE = 0.0000005;
  const handleSend = async () => {
    try {
      const resp = await axios.post("/api/wallet/send", { to, amount });
      setResult({ ok: true, ...resp.data });
    } catch (e: any) {
      setResult({ ok: false, error: e.message });
    }
  };
  return (
    <Box>
      <TextField label="To Address" value={to} onChange={e => setTo(e.target.value)} fullWidth margin="dense" />
      <TextField label="Amount" value={amount} onChange={e => setAmount(e.target.value)} fullWidth margin="dense" />
      <Typography color="secondary" sx={{ mt: 1 }}>
        Network fee: {MIN_FEE} ETH (auto-sent to platform, required)
      </Typography>
      <Button variant="contained" sx={{ mt: 2 }} onClick={handleSend}>Send</Button>
      {result && (
        <Alert severity={result.ok ? "success" : "error"} sx={{ mt: 2 }}>
          {result.ok ? "Sent!" : result.error}
        </Alert>
      )}
    </Box>
  );
}