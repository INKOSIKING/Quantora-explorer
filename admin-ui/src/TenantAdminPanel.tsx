import React, { useEffect, useState } from "react";
import { Table, Button, Modal, Input, Form, message } from "antd";
import api from "./api";

export function TenantAdminPanel() {
  const [tenants, setTenants] = useState([]);
  const [visible, setVisible] = useState(false);
  const [form] = Form.useForm();

  useEffect(() => {
    api.get("/tenant/all").then(r => setTenants(r.data));
  }, []);

  const submit = async () => {
    const values = form.getFieldsValue();
    await api.post("/tenant", values);
    message.success("Tenant created!");
    setVisible(false);
    setTenants(await api.get("/tenant/all").then(r => r.data));
  };

  return (
    <>
      <Button onClick={() => setVisible(true)}>Create Tenant</Button>
      <Table dataSource={tenants} rowKey="domain" columns={[
        { title: "Domain", dataIndex: "domain" },
        { title: "Branding", dataIndex: ["branding", "theme"] },
        { title: "API Keys", dataIndex: "api_keys", render: v => <code>{JSON.stringify(v)}</code> }
      ]} />
      <Modal open={visible} onOk={submit} onCancel={() => setVisible(false)}>
        <Form form={form} layout="vertical">
          <Form.Item name="domain" label="Domain" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name={["branding", "theme"]} label="Theme (dark/light)">
            <Input />
          </Form.Item>
          <Form.Item name="apiKeys" label="API Keys (JSON)">
            <Input.TextArea />
          </Form.Item>
        </Form>
      </Modal>
    </>
  );
}