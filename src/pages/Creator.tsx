import React, { useState } from "react";
import { Box, Tabs, Tab } from "@mui/material";
import TokenCreator from "../modules/creator/TokenCreator";
import NFTCreator from "../modules/creator/NFTCreator";
import DAOCreator from "../modules/creator/DAOCreator";

export default function Creator() {
  const [tab, setTab] = useState(0);
  return (
    <Box>
      <Tabs value={tab} onChange={(_, t) => setTab(t)}>
        <Tab label="Token" />
        <Tab label="NFT" />
        <Tab label="DAO" />
      </Tabs>
      <Box sx={{ mt: 2 }}>
        {tab === 0 && <TokenCreator />}
        {tab === 1 && <NFTCreator />}
        {tab === 2 && <DAOCreator />}
      </Box>
    </Box>
  );
}