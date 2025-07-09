import React from "react";
import { AppBar, Toolbar, Typography, Button } from "@mui/material";
import { Link as RouterLink } from "react-router-dom";

export default function NavBar() {
  return (
    <AppBar position="static">
      <Toolbar>
        <Typography variant="h6" sx={{ flexGrow: 1 }}>
          Quantora
        </Typography>
        <Button color="inherit" component={RouterLink} to="/">Dashboard</Button>
        <Button color="inherit" component={RouterLink} to="/creator">Create</Button>
        <Button color="inherit" component={RouterLink} to="/governance">Governance</Button>
        <Button color="inherit" component={RouterLink} to="/ai">AI Verify</Button>
        <Button color="inherit" component={RouterLink} to="/validators">Validators</Button>
        <Button color="inherit" component={RouterLink} to="/settings">Settings</Button>
      </Toolbar>
    </AppBar>
  );
}