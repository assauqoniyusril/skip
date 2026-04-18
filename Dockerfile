FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libpq-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libicu-dev

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql mysqli zip exif pcntl bcmath intl


# INSTAL EKSTENSI REDIS via PECL
RUN pecl install redis && docker-php-ext-enable redis

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


WORKDIR /var/www/html/skpi

RUN chown -R www-data:www-data /var/www/html/skpi

# Copy application files
COPY ./src /var/www/html/skpi

# Set permissions
RUN chown -R www-data:www-data /var/www/html/skpi \
    && chmod -R 755 /var/www/html/skpi/storage \
    && chmod -R 755 /var/www/html/skpi/bootstrap/cache

USER www-data
EXPOSE 9000