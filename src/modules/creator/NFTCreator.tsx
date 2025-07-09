import React, { useState } from "react";
import { Box, TextField, Button, Alert, Typography } from "@mui/material";
import axios from "axios";
export default function NFTCreator() {
  const [form, setForm] = useState({
    name: "", symbol: "", base_uri: "", max_supply: "", owner: "",
    mintable: true, burnable: false, pausable: false, royalties: "0",
  });
  const [result, setResult] = useState<any>(null);
  const MIN_FEE = 0.000001;
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    setForm({ ...form, [e.target.name]: e.target.value });
  const handleSubmit = async () => {
    try {
      const data = await axios.post("/api/creator/nft", { user: form.owner, ...form });
      setResult({ ok: true, ...data.data });
    } catch (e: any) {
      setResult({ ok: false, error: e.message });
    }
  };
  return (
    <Box>
      <TextField label="Name" name="name" value={form.name} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Symbol" name="symbol" value={form.symbol} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Base URI" name="base_uri" value={form.base_uri} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Max Supply" name="max_supply" value={form.max_supply} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Owner Address" name="owner" value={form.owner} onChange={handleChange} fullWidth margin="dense" />
      <TextField label="Royalties" name="royalties" value={form.royalties} onChange={handleChange} fullWidth margin="dense" />
      <Typography color="secondary" sx={{ mt: 1 }}>
        Network fee: {MIN_FEE} ETH (required, sent to maintainer)
      </Typography>
      <Button variant="contained" sx={{ mt: 2 }} onClick={handleSubmit}>Create NFT</Button>
      {result && (
        <Alert severity={result.ok ? "success" : "error"} sx={{ mt: 2 }}>
          {result.ok ? `NFT deployed: ${result.contract_address}` : result.error}
        </Alert>
      )}
    </Box>
  );
}