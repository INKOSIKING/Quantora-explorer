import { Injectable, BadRequestException, ForbiddenException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from './order.entity';
import { Wallet } from '../wallet/wallet.entity';
import { CreateOrderDto } from './dto/create-order.dto';
import { TradeService } from '../trade/trade.service';
import { AuditService } from '../audit/audit.service';

@Injectable()
export class OrderService {
  constructor(
    @InjectRepository(Order) private orders: Repository<Order>,
    @InjectRepository(Wallet) private wallets: Repository<Wallet>,
    private tradeService: TradeService,
    private auditService: AuditService,
  ) {}

  async placeOrder(userId: string, dto: CreateOrderDto): Promise<Order> {
    // 1. Validate order params
    if (!dto.pair || !dto.side || !dto.amount || !dto.price) {
      throw new BadRequestException('Missing required order parameters');
    }
    if (dto.amount <= 0) throw new BadRequestException('Order amount must be > 0');
    if (dto.price <= 0) throw new BadRequestException('Order price must be > 0');
    if (!['buy', 'sell'].includes(dto.side)) throw new BadRequestException('Invalid order side');

    // 2. Validate user wallet and sufficient balance (for 'buy', require USD; for 'sell', require asset)
    const wallet = await this.wallets.findOne({ where: { user: { id: userId } } });
    if (!wallet) throw new NotFoundException('Wallet not found');
    const [base, quote] = dto.pair.split('-');
    if (dto.side === 'buy') {
      const required = dto.amount * dto.price;
      if ((wallet.balances[quote] ?? 0) < required)
        throw new ForbiddenException('Insufficient balance');
    } else {
      if ((wallet.balances[base] ?? 0) < dto.amount)
        throw new ForbiddenException('Insufficient asset');
    }

    // 3. Freeze funds (simulate atomicity)
    try {
      if (dto.side === 'buy') wallet.balances[quote] -= dto.amount * dto.price;
      else wallet.balances[base] -= dto.amount;
      await this.wallets.save(wallet);
    } catch (e) {
      throw new BadRequestException('Could not reserve funds');
    }

    // 4. Save order, log audit
    const order = this.orders.create({ ...dto, user: { id: userId }, status: 'open' });
    await this.orders.save(order);
    await this.auditService.log('ORDER_PLACED', userId, { orderId: order.id, ...dto });

    // 5. Try to match (may create trades, fill/partial/cancel)
    try {
      await this.tradeService.match(order);
    } catch (e) {
      order.status = 'error';
      await this.orders.save(order);
      throw new BadRequestException('Order matching failed');
    }

    return order;
  }
}