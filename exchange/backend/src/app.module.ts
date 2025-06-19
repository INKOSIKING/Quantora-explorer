import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserModule } from './user/user.module';
import { WalletModule } from './wallet/wallet.module';
import { OrderModule } from './order/order.module';
import { TradeModule } from './trade/trade.module';
import { KycModule } from './kyc/kyc.module';
import { StakingModule } from './staking/staking.module';
import { ReferralModule } from './referral/referral.module';
import { LoyaltyModule } from './loyalty/loyalty.module';
import { AuditModule } from './audit/audit.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      url: process.env.DATABASE_URL || 'postgres://postgres@localhost/quantora',
      autoLoadEntities: true,
      synchronize: true,
    }),
    UserModule,
    WalletModule,
    OrderModule,
    TradeModule,
    KycModule,
    StakingModule,
    ReferralModule,
    LoyaltyModule,
    AuditModule,
  ],
})
export class AppModule {}