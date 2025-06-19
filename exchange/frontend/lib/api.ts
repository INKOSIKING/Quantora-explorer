import axios from "axios";

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || "http://localhost:8002",
  withCredentials: true,
});

export default {
  get: (url: string) => api.get(url),
  post: (url: string, data: any) => api.post(url, data),
  login: (email: string) => api.post("/auth/login", { email }).then((r) => r.data),
};