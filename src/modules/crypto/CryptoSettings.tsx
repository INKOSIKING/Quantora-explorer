import React, { useState, useEffect } from "react";
import axios from "axios";
import { Paper, Typography, Select, MenuItem, FormControl, InputLabel, Button } from "@mui/material";

const suites = [
  { value: "Legacy", label: "Legacy (ECDSA/Ed25519)" },
  { value: "QuantumSafe:Falcon", label: "Quantum Safe: Falcon" },
  { value: "QuantumSafe:Dilithium", label: "Quantum Safe: Dilithium" },
  { value: "QuantumSafe:SphincsPlus", label: "Quantum Safe: Sphincs+" },
];
export default function CryptoSettings() {
  const [suite, setSuite] = useState("Legacy");
  useEffect(() => {
    axios.get("/api/crypto/suite").then(r => setSuite(r.data));
  }, []);
  const updateSuite = () => {
    axios.post("/api/crypto/suite", { suite });
  };
  return (
    <Paper sx={{ p: 3 }}>
      <Typography variant="h6">Current Crypto Suite</Typography>
      <FormControl fullWidth>
        <InputLabel>Suite</InputLabel>
        <Select value={suite} label="Suite" onChange={e => setSuite(e.target.value)}>
          {suites.map(s => <MenuItem key={s.value} value={s.value}>{s.label}</MenuItem>)}
        </Select>
      </FormControl>
      <Button variant="contained" sx={{ mt: 2 }} onClick={updateSuite}>Set Suite</Button>
    </Paper>
  );
}