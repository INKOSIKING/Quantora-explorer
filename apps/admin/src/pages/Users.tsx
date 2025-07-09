import React, { useEffect, useState } from "react";
import axios from "axios";

type User = {
  id: string;
  name: string;
  status: string;
  kycStatus: string;
};

export default function Users() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios.get("/api/admin/users").then(res => {
      setUsers(res.data.users);
      setLoading(false);
    });
  }, []);

  return (
    <div>
      <h1>Users</h1>
      {loading ? (
        <p>Loading...</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Status</th>
              <th>KYC Status</th>
            </tr>
          </thead>
          <tbody>
            {users.map(u => (
              <tr key={u.id}>
                <td>{u.id}</td>
                <td>{u.name}</td>
                <td>{u.status}</td>
                <td>{u.kycStatus}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}