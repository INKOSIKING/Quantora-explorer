import { Controller, Get, Post, Body, Req, UseGuards } from '@nestjs/common';
import { WalletService } from './wallet.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('wallet')
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  @UseGuards(JwtAuthGuard)
  @Get('balance')
  async balance(@Req() req) {
    return this.walletService.getBalance(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Post('send')
  async send(@Req() req, @Body() dto: { to: string, token: string, amount: number }) {
    return this.walletService.send(req.user.id, dto.to, dto.token, dto.amount);
  }
}