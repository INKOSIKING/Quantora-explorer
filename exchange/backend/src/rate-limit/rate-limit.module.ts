import { Module } from '@nestjs/common';
import { ThrottlerModule } from '@nestjs/throttler';
import { ThrottlerStorageRedisService } from 'nestjs-throttler-storage-redis';

@Module({
  imports: [
    ThrottlerModule.forRootAsync({
      useFactory: () => ({
        ttl: 60,
        limit: 30,
        storage: new ThrottlerStorageRedisService('redis://redis:6379'), // Replace with your Redis URL
      }),
    }),
  ],
  exports: [ThrottlerModule],
})
export class RateLimitModule {}