import useSWR from 'swr'
import { useState } from 'react'

const fetcher = (url: string) => fetch(url).then(r => r.json())

export default function Home() {
  const { data: assets } = useSWR('/api/assets', fetcher)
  const [user, setUser] = useState('alice')
  const [symbol, setSymbol] = useState('btc')
  const { data: balance } = useSWR(() => user && symbol ? ['/api/balance', user, symbol].join('/'): null, fetcher)
  const [swapFrom, setSwapFrom] = useState('btc')
  const [swapTo, setSwapTo] = useState('qta')
  const [swapAmount, setSwapAmount] = useState('1')
  const [swapRes, setSwapRes] = useState('')

  async function doSwap() {
    setSwapRes('...')
    const res = await fetch('/api/swap', {
      method: 'POST', headers: {'Content-Type':'application/json'},
      body: JSON.stringify({ user, from: swapFrom, to: swapTo, amount: swapAmount })
    })
    const data = await res.json()
    setSwapRes(res.ok ? `Received: ${data.received}` : data)
  }

  return (
    <main style={{padding:30}}>
      <h1>Quantora Explorer</h1>
      <div>
        <label>User: <input value={user} onChange={e=>setUser(e.target.value)} /></label>
      </div>
      <div>
        <label>Select asset: 
          <select value={symbol} onChange={e=>setSymbol(e.target.value)}>
            {assets?.assets.map((s:string) => <option key={s} value={s}>{s.toUpperCase()}</option>)}
          </select>
        </label>
        <span> Balance: {balance?.balance ?? '...'}</span>
      </div>
      <div style={{marginTop:30}}>
        <h2>Swap</h2>
        <input value={swapFrom} onChange={e=>setSwapFrom(e.target.value)} placeholder="from symbol" />
        <input value={swapTo} onChange={e=>setSwapTo(e.target.value)} placeholder="to symbol" />
        <input value={swapAmount} onChange={e=>setSwapAmount(e.target.value)} placeholder="amount" />
        <button onClick={doSwap}>Swap</button>
        <span style={{marginLeft:20}}>{swapRes}</span>
      </div>
    </main>
  )
}