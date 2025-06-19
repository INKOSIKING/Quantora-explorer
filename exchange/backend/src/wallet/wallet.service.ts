import { Injectable, NotFoundException, BadRequestException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Wallet } from './wallet.entity';
import { AuditService } from '../audit/audit.service';

@Injectable()
export class WalletService {
  constructor(
    @InjectRepository(Wallet) private wallets: Repository<Wallet>,
    private auditService: AuditService,
  ) {}

  async send(userId: string, to: string, token: string, amount: number): Promise<any> {
    if (!to || !token || !amount || amount <= 0) throw new BadRequestException('Invalid send params');
    if (userId === to) throw new ForbiddenException('Cannot send to self');

    const fromWallet = await this.wallets.findOne({ where: { user: { id: userId } } });
    if (!fromWallet) throw new NotFoundException('Sender wallet not found');
    if ((fromWallet.balances[token] ?? 0) < amount) throw new ForbiddenException('Insufficient funds');

    const toWallet = await this.wallets.findOne({ where: { user: { id: to } } });
    if (!toWallet) throw new NotFoundException('Recipient wallet not found');

    // Simulate atomic DB transaction
    try {
      fromWallet.balances[token] -= amount;
      toWallet.balances[token] = (toWallet.balances[token] ?? 0) + amount;
      await this.wallets.save([fromWallet, toWallet]);
      await this.auditService.log('SEND', userId, { to, token, amount });
    } catch (e) {
      throw new BadRequestException('Send failed, DB error');
    }
    return { status: "ok" };
  }
}