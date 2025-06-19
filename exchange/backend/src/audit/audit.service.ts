import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditLog } from './audit.entity';

@Injectable()
export class AuditService {
  constructor(@InjectRepository(AuditLog) private audits: Repository<AuditLog>) {}

  async log(action: string, userId: string, detail: any) {
    await this.audits.save(this.audits.create({
      action,
      userId,
      detail: JSON.stringify(detail),
      timestamp: new Date()
    }));
  }
}