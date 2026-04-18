FROM php:8.2-fpm-alpine

# Instal dependensi sistem dan alat build
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    oniguruma-dev \
    icu-dev \
    autoconf \
    g++ \
    make

# Instal ekstensi PHP standar
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl

# INSTAL EKSTENSI REDIS via PECL
RUN pecl install redis && docker-php-ext-enable redis

# Ambil Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html

USER www-data
EXPOSE 9000
CMD ["php-fpm"]