# Quantora Auth Service

## Features
- JWT authentication (access/refresh)
- Registration, login, logout, refresh
- Password reset via email
- OAuth2 (Google, GitHub, etc)
- RBAC (roles: user, admin, etc)
- Admin user management
- Swagger/OpenAPI docs at `/docs`
- Secure, scalable, microservice-ready

## API
- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/refresh`
- `POST /auth/logout`
- `GET /auth/me`
- `POST /password-reset/request`
- `POST /password-reset/reset`
- `GET /users/` (admin)
- `PUT /users/:id/roles` (admin)
- `GET /docs` (Swagger)

## Usage

- Import `sdk/js/auth.ts` in other services and apps.
- Use `authenticateJWT` and `requireRoles` in API gateway and microservices.

## Environment

- Set `JWT_SECRET`, `JWT_REFRESH_SECRET`, email and OAuth secrets in environment.

---

**Contact Quantora Security Team for security reviews and deployment guides.**