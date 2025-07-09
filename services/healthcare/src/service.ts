let doctors: any[] = [];
let appointments: any[] = [];
let doctorId = 1;
let appointmentId = 1;

export async function registerDoctor(doctor: string, specialty: string) {
  const id = doctorId++;
  doctors.push({ id, doctor, specialty });
  return { id, status: "registered" };
}

export async function bookAppointment(patient: string, doctorId: number, time: string) {
  const doctor = doctors.find(d => d.id === doctorId);
  if (!doctor) return { error: "doctor not found" };
  const id = appointmentId++;
  appointments.push({ id, patient, doctorId, time, status: "booked" });
  return { id, doctorId, time, status: "booked" };
}

export async function getDoctors() {
  return doctors;
}