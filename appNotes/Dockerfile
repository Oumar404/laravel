# backend/Dockerfile
FROM php:8.2-fpm

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libjpeg-dev libfreetype6-dev zip unzip \
    && docker-php-ext-install pdo_mysql

# Installer Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN composer install
RUN php artisan key:generate

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
EXPOSE 8000
