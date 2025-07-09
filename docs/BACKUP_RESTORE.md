# Backup & Restore: Disaster Recovery

## Databases

- Schedule nightly postgres dumps:
  - `pg_dump -Fc -d quantora > backup_$(date +%F).dump`
- Test restore:
  - `pg_restore -C -d postgres backup_YYYY-MM-DD.dump`

## Redis

- Configure AOF or RDB persistence
- Test restore with:
  - `cp dump.rdb /var/lib/redis/`
  - Restart Redis

## Simulate Disaster

1. Drop DB, clear Redis.
2. Restore from last backup.
3. Run smoke/e2e tests.