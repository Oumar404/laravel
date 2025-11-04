#!/usr/bin/env sh
set -e

cd /var/www

# Ensure .env exists
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
fi

# Generate APP_KEY at runtime if missing/empty
if ! grep -q '^APP_KEY=' .env || [ -z "$(grep '^APP_KEY=' .env | cut -d= -f2)" ]; then
  php artisan key:generate --force || true
fi

# Fix permissions (best-effort)
chown -R www-data:www-data storage bootstrap/cache || true
chmod -R 775 storage bootstrap/cache || true

exec php artisan serve --host=0.0.0.0 --port=8000
