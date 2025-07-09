import { useEffect, useState } from "react";
export default function Accounts() {
  const [accounts, setAccounts] = useState([]);
  useEffect(() => {
    fetch("/api/accounts", { headers: { "Authorization": "Bearer jwt-1" }}).then(r => r.json()).then(setAccounts);
  }, []);
  return (
    <div>
      <h2>Your Accounts</h2>
      <ul>
        {accounts.map((a: any) => <li key={a.id}>{a.name} - ${a.balance}</li>)}
      </ul>
    </div>
  );
}