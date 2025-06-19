import { useRouter } from 'next/router';
import { useEffect, useState } from 'react';
import api from '../../lib/api';

export default function AnalyticsPage() {
  const { address } = useRouter().query;
  const [analytics, setAnalytics] = useState<any>(null);

  useEffect(() => {
    if (address) {
      api.get(`/analytics/${address}`).then(r => setAnalytics(r.data));
    }
  }, [address]);

  return (
    <div>
      <h2>Analytics for {address}</h2>
      {analytics && (
        <ul>
          <li>Tx Count: {analytics.tx_count}</li>
          <li>Total Value: {analytics.total_value}</li>
        </ul>
      )}
      {!analytics && <p>No analytics available.</p>}
    </div>
  );
}