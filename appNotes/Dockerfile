# backend/Dockerfile
FROM php:8.2-fpm

# Build cache buster (set via build-arg)
ARG BUILD_REV=local

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libjpeg-dev libfreetype6-dev zip unzip \
    && docker-php-ext-install pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Installer Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copier les fichiers composer d'abord pour profiter du cache
COPY composer.json composer.lock ./

# Installer les dépendances sans exécuter les scripts (artisan n'existe pas encore)
RUN composer install --no-interaction --prefer-dist --no-dev --no-scripts

# Copier le reste de l'application
COPY . .

# Maintenant que artisan existe, régénérer l'autoloader avec les scripts
RUN composer dump-autoload --optimize --no-dev

# Ne pas générer la clé à la build; l'entrypoint gère .env & APP_KEY à l'exécution
RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 775 storage/bootstrap/cache

# Entrypoint pour générer la clé à l'exécution et démarrer le serveur
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
