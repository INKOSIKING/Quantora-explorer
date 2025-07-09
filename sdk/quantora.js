import axios from "axios";

export class QuantoraClient {
  constructor(baseUrl = "/api/v1") {
    this.baseUrl = baseUrl;
  }

  async getBlock(blockHash) {
    return axios.get(`${this.baseUrl}/block/${blockHash}`).then(r => r.data);
  }

  async search(q) {
    return axios.get(`${this.baseUrl}/search`, { params: { q } }).then(r => r.data);
  }

  async newOrder(token, pair, orderType, size, price) {
    return axios.post(
      `${this.baseUrl}/order`,
      { pair, type: orderType, size, ...(price && { price }) },
      { headers: { Authorization: `Bearer ${token}` } }
    ).then(r => r.data);
  }
}