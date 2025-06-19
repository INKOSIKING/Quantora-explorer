import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class AuditLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  action: string;

  @Column()
  userId: string;

  @Column({ type: 'text' })
  detail: string;

  @Column()
  timestamp: Date;
}