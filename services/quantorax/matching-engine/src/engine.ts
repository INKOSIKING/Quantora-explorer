interface Order {
  id: string;
  trader: string;
  side: "buy" | "sell";
  price: number;
  amount: number;
  filled: number;
  timestamp: number;
}

export class Orderbook {
  private bids: Order[] = [];
  private asks: Order[] = [];

  addOrder(order: Order) {
    if (order.side === "buy") {
      this.bids.push(order);
      this.bids.sort((a, b) => b.price - a.price || a.timestamp - b.timestamp);
    } else {
      this.asks.push(order);
      this.asks.sort((a, b) => a.price - b.price || a.timestamp - b.timestamp);
    }
    this.match();
  }

  match() {
    while (this.bids.length && this.asks.length && this.bids[0].price >= this.asks[0].price) {
      const buy = this.bids[0];
      const sell = this.asks[0];
      const tradeAmount = Math.min(buy.amount - buy.filled, sell.amount - sell.filled);

      // Fill orders
      buy.filled += tradeAmount;
      sell.filled += tradeAmount;

      // Remove filled orders
      if (buy.filled === buy.amount) this.bids.shift();
      if (sell.filled === sell.amount) this.asks.shift();

      // Emit trade event (to database, websocket, settlement, etc.)
      console.log(`Trade: ${buy.trader} buys from ${sell.trader} amount ${tradeAmount} at price ${sell.price}`);
    }
  }
}