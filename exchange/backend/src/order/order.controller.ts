import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { OrderService } from './order.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateOrderDto } from './dto/create-order.dto';

@Controller('order')
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  async place(@Req() req, @Body() dto: CreateOrderDto) {
    const order = await this.orderService.placeOrder(req.user.id, dto);
    return order;
  }
}