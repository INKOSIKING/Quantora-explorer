let vehicles: any[] = [];
let rides: any[] = [];
let vehicleId = 1;
let rideId = 1;

export async function registerVehicle(owner: string, vehicle: any) {
  const id = vehicleId++;
  vehicles.push({ id, owner, ...vehicle, available: true });
  return { id, status: "registered" };
}

export async function bookRide(user: string, vehicleId: number, from: string, to: string) {
  const vehicle = vehicles.find(v => v.id === vehicleId && v.available);
  if (!vehicle) return { error: "vehicle not available" };
  vehicle.available = false;
  const id = rideId++;
  rides.push({ id, user, vehicleId, from, to, status: "booked" });
  return { id, vehicleId, from, to, status: "booked" };
}

export async function getAvailableVehicles() {
  return vehicles.filter(v => v.available);
}