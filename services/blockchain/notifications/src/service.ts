const subscriptions: Record<string, { type: string; endpoint: string }[]> = {};

export async function subscribe(address: string, type: string, endpoint: string) {
  if (!subscriptions[address]) subscriptions[address] = [];
  subscriptions[address].push({ type, endpoint });
}

export async function unsubscribe(address: string, type: string) {
  if (!subscriptions[address]) return;
  subscriptions[address] = subscriptions[address].filter(s => s.type !== type);
}

export async function sendNotification(address: string, payload: any) {
  // Send notification to all endpoints of this address (push, email, SMS, webhook, etc.)
  if (!subscriptions[address]) return;
  for (const sub of subscriptions[address]) {
    // Example: push notification logic here
    console.log(`Sending ${sub.type} notification to ${sub.endpoint}:`, payload);
  }
}