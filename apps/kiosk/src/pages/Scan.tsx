import React, { useState } from "react";

export default function ScanPage() {
  const [result, setResult] = useState<string | null>(null);

  const handleScan = () => {
    // Simulate QR code scanning
    setTimeout(() => setResult("0xABCDEF1234567890"), 1000);
  };

  return (
    <div>
      <h1>Kiosk QR Code Scan</h1>
      <button onClick={handleScan}>Scan QR</button>
      {result && (
        <div>
          <p>Scanned Address:</p>
          <strong>{result}</strong>
        </div>
      )}
    </div>
  );
}