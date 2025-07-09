import { expect } from "chai";
import request from "supertest";
import app from "../../templates/ecommerce/backend/src/app";

describe("Order Flow", () => {
  it("creates and retrieves an order", async () => {
    const order = { userId: 1, productIds: [1], total: 20 };
    const create = await request(app).post("/api/orders").send(order);
    expect(create.status).to.equal(201);
    const get = await request(app).get("/api/orders/" + create.body.id);
    expect(get.body.id).to.equal(create.body.id);
  });
});