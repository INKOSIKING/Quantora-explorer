import React, { useEffect, useState } from "react";
import { Table, Card, Tag, Tabs, Modal, Button } from "antd";
import api from "./api";

export function AdminAdvancedDashboard() {
  const [portfolios, setPortfolios] = useState([]);
  const [stakings, setStakings] = useState([]);
  const [comments, setComments] = useState([]);
  const [referrals, setReferrals] = useState([]);
  const [loyalties, setLoyalties] = useState([]);
  const [bugs, setBugs] = useState([]);
  const [verifiedContracts, setVerifiedContracts] = useState([]);

  useEffect(() => {
    api.get("/analytics/portfolio").then(r => setPortfolios(r.data));
    api.get("/staking/all").then(r => setStakings(r.data));
    api.get("/community/comments/all").then(r => setComments(r.data));
    api.get("/referral/all").then(r => setReferrals(r.data));
    api.get("/loyalty/all").then(r => setLoyalties(r.data));
    api.get("/community/bug/all").then(r => setBugs(r.data));
    api.get("/contracts/verified").then(r => setVerifiedContracts(r.data));
  }, []);

  return (
    <Tabs>
      <Tabs.TabPane tab="Portfolios" key="1">
        <Table dataSource={portfolios} columns={[
          { title: "User", dataIndex: "user_id" },
          { title: "Token", dataIndex: "token" },
          { title: "Balance", dataIndex: "balance" },
          { title: "USD", dataIndex: "usd_value" },
        ]} />
      </Tabs.TabPane>
      <Tabs.TabPane tab="Staking" key="2">
        <Table dataSource={stakings} columns={[
          { title: "User", dataIndex: "user_id" },
          { title: "Amount", dataIndex: "amount" },
          { title: "Since", dataIndex: "since" }
        ]} />
      </Tabs.TabPane>
      <Tabs.TabPane tab="Loyalty" key="3">
        <Table dataSource={loyalties} columns={[
          { title: "User", dataIndex: "user_id" },
          { title: "Points", dataIndex: "points" }
        ]} />
      </Tabs.TabPane>
      <Tabs.TabPane tab="Referrals" key="4">
        <Table dataSource={referrals} columns={[
          { title: "Referrer", dataIndex: "referrer" },
          { title: "Referred", dataIndex: "referred" },
          { title: "Bonus", dataIndex: "bonus" }
        ]} />
      </Tabs.TabPane>
      <Tabs.TabPane tab="Community" key="5">
        <Table dataSource={comments} columns={[
          { title: "User", dataIndex: "user_id" },
          { title: "Target", dataIndex: "target" },
          { title: "Comment", dataIndex: "body" },
          { title: "Time", dataIndex: "created_at" }
        ]} />
        <Table dataSource={bugs} columns={[
          { title: "User", dataIndex: "user_id" },
          { title: "Page", dataIndex: "page" },
          { title: "Detail", dataIndex: "detail" },
          { title: "Time", dataIndex: "created_at" }
        ]} />
      </Tabs.TabPane>
      <Tabs.TabPane tab="Verified Contracts" key="6">
        <Table dataSource={verifiedContracts} columns={[
          { title: "Address", dataIndex: "address" },
          { title: "Verified", dataIndex: "verified", render: v => v ? <Tag color="green">Yes</Tag> : <Tag>No</Tag> }
        ]} />
      </Tabs.TabPane>
    </Tabs>
  );
}