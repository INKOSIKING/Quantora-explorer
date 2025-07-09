import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import { StatsChart } from "../StatsChart";

global.fetch = jest.fn().mockImplementation((url) => {
  if (url.includes("/api/stats/daily")) {
    return Promise.resolve({
      json: () => Promise.resolve([
        {
          day: "2025-06-14",
          blocks: 100,
          txs: 500,
          avg_block_time: 13.1,
        }
      ]),
    });
  }
  return Promise.reject(new Error("Not found"));
}) as any;

describe("StatsChart", () => {
  it("renders stats table", async () => {
    render(<StatsChart />);
    expect(screen.getByText(/Loading stats/i)).toBeInTheDocument();
    await waitFor(() =>
      expect(screen.getByText(/Historical Stats/)).toBeInTheDocument()
    );
    expect(screen.getByText(/2025-06-14/)).toBeInTheDocument();
    expect(screen.getByText(/100/)).toBeInTheDocument();
    expect(screen.getByText(/500/)).toBeInTheDocument();
    expect(screen.getByText(/13.10/)).toBeInTheDocument();
  });
});