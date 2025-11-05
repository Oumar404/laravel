#!/usr/bin/env sh
set -e

cd /var/www

# Ensure .env exists
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
fi

# Generate APP_KEY at runtime only if not provided via env and not present in .env
NEED_KEY=0
if [ -z "${APP_KEY:-}" ]; then
  if ! grep -q '^APP_KEY=' .env 2>/dev/null; then
    NEED_KEY=1
  else
    VAL=$(grep '^APP_KEY=' .env | cut -d= -f2-)
    [ -z "$VAL" ] && NEED_KEY=1
  fi
fi

if [ "$NEED_KEY" = "1" ]; then
  php artisan key:generate --force || true
fi

# Fix permissions (best-effort)
chown -R www-data:www-data storage bootstrap/cache || true
chmod -R 775 storage/bootstrap/cache || true

exec "$@"
