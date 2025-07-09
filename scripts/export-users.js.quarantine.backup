const fs = require('fs');
const { Client } = require('pg');

const client = new Client({ connectionString: process.env.DATABASE_URL });

(async () => {
  await client.connect();
  const res = await client.query('SELECT id, email, created_at FROM users');
  fs.writeFileSync('users_export.json', JSON.stringify(res.rows, null, 2));
  await client.end();
  console.log('Exported users to users_export.json');
})();