import { Controller, Get, Post, Body, Req, UseGuards } from '@nestjs/common';
import { UserService } from './user.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateUserDto } from './dto/create-user.dto';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('register')
  async register(@Body() dto: CreateUserDto) {
    const user = await this.userService.create(dto);
    return { id: user.id, email: user.email };
  }

  @UseGuards(JwtAuthGuard)
  @Get('wallet')
  async getWallet(@Req() req) {
    const wallet = await this.userService.getWallet(req.user.id);
    return wallet;
  }
}