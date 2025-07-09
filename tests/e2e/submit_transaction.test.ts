import axios from "axios";

describe("Transaction Submission", () => {
  it("should submit a transaction and return a receipt", async () => {
    const res = await axios.post("http://localhost:8080/api/tx/send", {
      from: "0xAlice",
      to: "0xBob",
      value: "1000",
    });
    expect(res.data).toHaveProperty("txHash");
    expect(res.data).toHaveProperty("status", "success");
  });
});