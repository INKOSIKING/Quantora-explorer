import React from "react";
import { Grid, Paper, Typography } from "@mui/material";
import RollupStatus from "../modules/rollup/RollupStatus";
import DAStatus from "../modules/da/DAStatus";
import BlockStats from "../modules/indexing/BlockStats";
import GovernanceOverview from "../modules/governance/GovernanceOverview";

export default function Dashboard() {
  return (
    <Grid container spacing={3} sx={{ p: 3 }}>
      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 2 }}><RollupStatus /></Paper>
      </Grid>
      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 2 }}><DAStatus /></Paper>
      </Grid>
      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 2 }}><BlockStats /></Paper>
      </Grid>
      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 2 }}><GovernanceOverview /></Paper>
      </Grid>
    </Grid>
  );
}