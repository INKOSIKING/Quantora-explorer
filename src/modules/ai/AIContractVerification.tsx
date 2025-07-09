import React, { useState } from "react";
import { Box, TextField, Button, Alert } from "@mui/material";
import axios from "axios";

export default function AIContractVerification() {
  const [bytecode, setBytecode] = useState("");
  const [src, setSrc] = useState("");
  const [vmType, setVmType] = useState("EVM");
  const [result, setResult] = useState<any>(null);

  const handleVerify = async () => {
    try {
      const resp = await axios.post("/api/ai/verify", { bytecode, source_code: src, vm_type: vmType });
      setResult(resp.data);
    } catch (e: any) {
      setResult({ valid: false, summary: e.message });
    }
  };

  return (
    <Box>
      <TextField label="Contract Bytecode" value={bytecode} onChange={e => setBytecode(e.target.value)} fullWidth margin="dense" multiline />
      <TextField label="Source Code (optional)" value={src} onChange={e => setSrc(e.target.value)} fullWidth margin="dense" multiline />
      <TextField label="VM Type" value={vmType} onChange={e => setVmType(e.target.value)} fullWidth margin="dense" />
      <Button variant="contained" sx={{ mt: 2 }} onClick={handleVerify}>AI Verify</Button>
      {result && (
        <Alert severity={result.valid ? "success" : "error"} sx={{ mt: 2 }}>
          {result.summary || (result.valid ? "Contract is valid" : "Invalid contract")}
        </Alert>
      )}
    </Box>
  );
}