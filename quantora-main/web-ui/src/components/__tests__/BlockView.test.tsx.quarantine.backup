import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import { BlockView } from "../BlockView";

global.fetch = jest.fn().mockImplementation((url) => {
  if (url.includes("/api/block/123")) {
    return Promise.resolve({
      json: () => Promise.resolve({
        number: 123,
        hash: "0xblockhash",
        parent_hash: "0xparenthash",
        timestamp: "2025-06-14T07:00:00Z",
      }),
    });
  }
  return Promise.reject(new Error("Not found"));
}) as any;

describe("BlockView", () => {
  it("renders block details", async () => {
    render(<BlockView number="123" />);
    expect(screen.getByText(/Loading block/i)).toBeInTheDocument();
    await waitFor(() =>
      expect(screen.getByText(/Block #123/)).toBeInTheDocument()
    );
    expect(screen.getByText(/0xblockhash/)).toBeInTheDocument();
    expect(screen.getByText(/0xparenthash/)).toBeInTheDocument();
    expect(screen.getByText(/2025-06-14T07:00:00Z/)).toBeInTheDocument();
  });
});