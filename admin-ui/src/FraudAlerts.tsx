import React, { useEffect, useState } from "react";
import { Table, Badge } from "antd";
import { getFraudAlerts } from "./api";

export const FraudAlerts: React.FC = () => {
  const [alerts, setAlerts] = useState<any[]>([]);
  useEffect(() => {
    const fetchAlerts = async () => setAlerts(await getFraudAlerts());
    fetchAlerts();
    const interval = setInterval(fetchAlerts, 10000);
    return () => clearInterval(interval);
  }, []);
  const columns = [
    { title: "User", dataIndex: "user_id" },
    { title: "Type", dataIndex: "type", render: (v: string) => <Badge status={v==="critical"?"error":"warning"} text={v} /> },
    { title: "Reason", dataIndex: "reason" },
    { title: "Time", dataIndex: "reported_at" }
  ];
  return <Table columns={columns} dataSource={alerts} rowKey="id" />;
};