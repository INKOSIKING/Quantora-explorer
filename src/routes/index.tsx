import React from "react";
import { Routes, Route } from "react-router-dom";
import Dashboard from "../pages/Dashboard";
import Creator from "../pages/Creator";
import Governance from "../pages/Governance";
import AI from "../pages/AI";
import Validators from "../pages/Validators";
import Settings from "../pages/Settings";

const AppRoutes = () => (
  <Routes>
    <Route path="/" element={<Dashboard />} />
    <Route path="/creator" element={<Creator />} />
    <Route path="/governance" element={<Governance />} />
    <Route path="/ai" element={<AI />} />
    <Route path="/validators" element={<Validators />} />
    <Route path="/settings" element={<Settings />} />
  </Routes>
);

export default AppRoutes;