let trips: any[] = [];
let bookings: any[] = [];
let tripId = 1;

export async function addTrip(provider: string, trip: any) {
  const id = tripId++;
  trips.push({ id, provider, ...trip });
  return { id, status: "added" };
}

export async function bookTrip(user: string, tripId: number) {
  const trip = trips.find(t => t.id === tripId);
  if (!trip) return { error: "trip not found" };
  bookings.push({ user, tripId, status: "booked" });
  return { user, tripId, status: "booked" };
}

export async function getTrips() {
  return trips;
}