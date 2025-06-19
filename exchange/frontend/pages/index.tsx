import { useState } from 'react';
export default function Home() {
  const [email, setEmail] = useState('');
  return (
    <div>
      <h1>Welcome to Quantora Exchange</h1>
      <form>
        <input type="email" value={email} onChange={e => setEmail(e.target.value)} />
        <button>Sign Up</button>
      </form>
    </div>
  );
}