import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Order } from './order.entity';
import { Wallet } from '../wallet/wallet.entity';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { TradeModule } from '../trade/trade.module';
import { AuditModule } from '../audit/audit.module';

@Module({
  imports: [TypeOrmModule.forFeature([Order, Wallet]), TradeModule, AuditModule],
  providers: [OrderService],
  controllers: [OrderController],
  exports: [OrderService],
})
export class OrderModule {}