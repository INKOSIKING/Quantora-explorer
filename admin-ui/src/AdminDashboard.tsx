import React, { useEffect, useState } from "react";
import { Table, Card, Alert, Button, Input } from "antd";
import { getSystemMetrics, getAuditLogs, approveKyc, freezeAccount } from "./api";

const columns = [
  { title: "User ID", dataIndex: "user_id" },
  { title: "Status", dataIndex: "kyc_status" },
  { title: "Last Reviewed", dataIndex: "reviewed_at" },
  {
    title: "Actions",
    render: (record: any) => (
      <span>
        <Button onClick={() => approveKyc(record.user_id)}>Approve</Button>
        <Button danger onClick={() => freezeAccount(record.user_id)}>Freeze</Button>
      </span>
    )
  }
];

export const AdminDashboard = () => {
  const [metrics, setMetrics] = useState<any>({});
  const [kycUsers, setKycUsers] = useState<any[]>([]);
  const [auditLogs, setAuditLogs] = useState<any[]>([]);

  useEffect(() => {
    getSystemMetrics().then(setMetrics);
    getAuditLogs().then(setAuditLogs);
    // Fetch KYC users...
  }, []);

  return (
    <div>
      <Card title="System Metrics">
        <Alert message={`Active Users: ${metrics.active_users}, Pending KYC: ${metrics.pending_kyc}`} />
      </Card>
      <Card title="KYC Queue">
        <Table columns={columns} dataSource={kycUsers} />
      </Card>
      <Card title="Recent Audit Events">
        <Table dataSource={auditLogs} columns={[
          { title: "Event", dataIndex: "event" },
          { title: "User", dataIndex: "user_id" },
          { title: "Details", dataIndex: "details" },
          { title: "Time", dataIndex: "timestamp" }
        ]} />
      </Card>
    </div>
  );
};