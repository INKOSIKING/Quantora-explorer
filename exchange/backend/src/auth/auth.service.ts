import { Injectable, UnauthorizedException, ForbiddenException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';
import { User } from '../user/user.entity';
import * as speakeasy from 'speakeasy';

@Injectable()
export class AuthService {
  constructor(private users: UserService, private jwt: JwtService) {}

  async validateUser(email: string, pass: string): Promise<User | null> {
    return this.users.validate(email, pass);
  }

  async login(user: User, mfaCode?: string) {
    // If user has MFA enabled, check code
    if (user.mfaSecret) {
      if (!mfaCode) throw new ForbiddenException('MFA code required');
      const verified = speakeasy.totp.verify({
        secret: user.mfaSecret,
        encoding: 'base32',
        token: mfaCode,
      });
      if (!verified) throw new ForbiddenException('Invalid MFA code');
    }
    const payload = { sub: user.id, email: user.email };
    return {
      access_token: this.jwt.sign(payload),
      refresh_token: this.jwt.sign(payload, { expiresIn: '7d' }),
    };
  }

  async enableMfa(userId: string) {
    const secret = speakeasy.generateSecret();
    // Save secret.base32 in user.mfaSecret (should use a transaction)
    await this.users.setMfaSecret(userId, secret.base32);
    return { otpauth_url: secret.otpauth_url, secret: secret.base32 };
  }
}