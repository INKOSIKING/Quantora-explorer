import axios from "axios";

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_EXPLORER_API_URL || "http://localhost:8003"
});

export default {
  get: (url: string) => api.get(url),
};