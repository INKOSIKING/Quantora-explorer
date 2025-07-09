import request from "supertest";
import app from "../backend/src/app";
describe("Accounts Endpoints (E2E)", () => {
  let token: string;
  beforeAll(async () => {
    // Register and login user
    await request(app).post("/api/users/register").send({
      email: "test@example.com", password: "123456", name: "TestUser"
    });
    const { body } = await request(app).post("/api/users/login").send({
      email: "test@example.com", password: "123456"
    });
    token = body.token;
  });
  it("should create, update, and delete account", async () => {
    const create = await request(app).post("/api/accounts")
      .set("Authorization", `Bearer ${token}`)
      .send({ name: "Main", type: "checking" });
    expect(create.status).toBe(201);
    const update = await request(app).patch(`/api/accounts/${create.body.id}`)
      .set("Authorization", `Bearer ${token}`)
      .send({ name: "Main Updated" });
    expect(update.body.name).toBe("Main Updated");
    const del = await request(app).delete(`/api/accounts/${create.body.id}`)
      .set("Authorization", `Bearer ${token}`);
    expect(del.status).toBe(204);
  });
});