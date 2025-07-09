import React, { useEffect, useState } from "react";
import axios from "axios";
import { Table, TableHead, TableRow, TableCell, TableBody, Paper, Typography } from "@mui/material";

export default function ValidatorSet() {
  const [validators, setValidators] = useState<any[]>([]);
  useEffect(() => {
    axios.get("/api/validators").then(r => setValidators(r.data));
  }, []);
  return (
    <Paper sx={{ p: 2 }}>
      <Typography variant="h6">Validator Set</Typography>
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>Address</TableCell>
            <TableCell>Stake</TableCell>
            <TableCell>Active</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {validators.map((v, i) => (
            <TableRow key={i}>
              <TableCell>{v.address}</TableCell>
              <TableCell>{v.stake}</TableCell>
              <TableCell>{v.active ? "Yes" : "No"}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </Paper>
  );
}