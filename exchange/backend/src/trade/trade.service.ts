import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from '../order/order.entity';

@Injectable()
export class TradeService {
  constructor(@InjectRepository(Order) private orders: Repository<Order>) {}

  async match(newOrder: Order): Promise<void> {
    // Very basic matching engine, for production use a dedicated high-performance engine.
    const matches = await this.orders.find({
      where: {
        pair: newOrder.pair,
        side: newOrder.side === 'buy' ? 'sell' : 'buy',
        price: newOrder.side === 'buy'
          ? { $lte: newOrder.price }
          : { $gte: newOrder.price }
      },
      order: { price: newOrder.side === 'buy' ? 'ASC' : 'DESC' }
    });

    for (const match of matches) {
      if (newOrder.amount === 0) break;
      const traded = Math.min(newOrder.amount, match.amount);
      // Update balances, reduce orders, log trade, etc.
      // ...
      newOrder.amount -= traded;
      match.amount -= traded;
      await this.orders.save([match, newOrder]);
      // If fully filled, break
    }
  }
}