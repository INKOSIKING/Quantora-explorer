let providers: any[] = [];
let bookings: any[] = [];
let providerId = 1;
let bookingId = 1;

export async function listProvider(provider: string, service: string) {
  const id = providerId++;
  providers.push({ id, provider, service });
  return { id, status: "listed" };
}

export async function bookService(user: string, providerId: number, serviceType: string) {
  const provider = providers.find(p => p.id === providerId && p.service === serviceType);
  if (!provider) return { error: "provider not found" };
  const id = bookingId++;
  bookings.push({ id, user, providerId, serviceType, status: "booked" });
  return { id, providerId, serviceType, status: "booked" };
}

export async function getProviders() {
  return providers;
}