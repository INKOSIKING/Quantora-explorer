import React, { useState } from "react";
import { Button, Input, Modal, Alert } from "antd";
import { requestWithdrawalLimitIncrease, submitKycDocs } from "./api";

export const UserSelfService = () => {
  const [visible, setVisible] = useState(false);
  const [limitReq, setLimitReq] = useState("");
  const [uploadMsg, setUploadMsg] = useState("");

  const handleLimitIncrease = () => {
    requestWithdrawalLimitIncrease(limitReq)
      .then(() => setVisible(false))
      .catch(() => setUploadMsg("Request failed"));
  };

  return (
    <div>
      <Button onClick={() => setVisible(true)}>Request Withdrawal Limit Increase</Button>
      <Modal visible={visible} onOk={handleLimitIncrease} onCancel={() => setVisible(false)}>
        <Input value={limitReq} onChange={e => setLimitReq(e.target.value)} placeholder="Desired daily limit" />
      </Modal>

      <Button onClick={() => submitKycDocs().then(() => setUploadMsg("Submitted")).catch(() => setUploadMsg("Error"))}>
        Upload/Update KYC Documents
      </Button>
      {uploadMsg && <Alert message={uploadMsg} type={uploadMsg === "Submitted" ? "success" : "error"} />}
    </div>
  );
};