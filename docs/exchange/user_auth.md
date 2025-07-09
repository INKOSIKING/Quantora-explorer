# User Registration, Authentication, and Security

## 1. Registration

- Email or phone signup (verifiable)
- Captcha and basic bot checks

## 2. Authentication

- Passwords (strong hash, bcrypt/argon2)
- OAuth2/social (optional)
- TOTP 2FA (required for withdrawals, recommended for login)
- Email/SMS OTP fallback

## 3. Recovery

- Multi-step email/phone reset
- Manual review for high-value accounts

## 4. Session Management

- JWT or secure session cookies
- Auto-logout on suspicious activity

## 5. Security

- Rate limits, brute force protection
- Device/browser fingerprinting

---