import { useRouter } from 'next/router';
import { useEffect, useState } from 'react';
import api from '../../lib/api';

export default function BlockPage() {
  const { block } = useRouter().query;
  const [data, setData] = useState(null);
  useEffect(() => {
    if (block) api.get(`/block/${block}`).then(r => setData(r.data));
  }, [block]);
  return (
    <div>
      <h2>Block Details</h2>
      {data && <pre>{JSON.stringify(data, null, 2)}</pre>}
    </div>
  );
}