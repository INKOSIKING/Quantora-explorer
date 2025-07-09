import axios from "axios";

export async function createToken(body: any) {
  const response = await axios.post("/api/creator/token", body);
  return response.data;
}
export async function createNFT(body: any) {
  const response = await axios.post("/api/creator/nft", body);
  return response.data;
}
export async function createDAO(body: any) {
  const response = await axios.post("/api/creator/dao", body);
  return response.data;
}