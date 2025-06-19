import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { KycService } from './kyc.service';

@Controller('kyc')
export class KycController {
  constructor(private readonly kyc: KycService) {}

  @Post('start')
  @UseGuards(JwtAuthGuard)
  async start(@Req() req: any, @Body() body: { provider: string }) {
    const userId = req.user.userId;
    return this.kyc.startKyc(userId, body.provider || 'sumsub');
  }

  @Post('webhook')
  async webhook(@Body() body: any) {
    // KYC provider webhook endpoint (Sumsub/Onfido, etc.)
    await this.kyc.processWebhook(body);
    return { status: 'ok' };
  }
}