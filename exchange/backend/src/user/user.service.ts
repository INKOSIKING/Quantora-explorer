import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import { Wallet } from '../wallet/wallet.entity';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User) private users: Repository<User>,
    @InjectRepository(Wallet) private wallets: Repository<Wallet>,
  ) {}

  async create(dto: CreateUserDto): Promise<User> {
    const user = this.users.create(dto);
    await this.users.save(user);
    const wallet = this.wallets.create({ user, balances: {} });
    await this.wallets.save(wallet);
    return user;
  }

  async findById(id: string): Promise<User> {
    const user = await this.users.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async getWallet(userId: string): Promise<Wallet> {
    const wallet = await this.wallets.findOne({ where: { user: { id: userId } } });
    if (!wallet) throw new NotFoundException('Wallet not found');
    return wallet;
  }
}