FROM php:8.3-fpm

# Install dependencies
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
    libicu-dev \
    libssl-dev \
    nano

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql mysqli zip exif pcntl bcmath intl opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


# Set working directory
WORKDIR /var/www/html

# Copy existing files
COPY ./src /var/www/html

# PERBAIKAN: Buat folder yang diperlukan jika belum ada, baru set permissions
RUN mkdir -p /var/www/html/skpi/storage/framework/cache/data \
    && mkdir -p /var/www/html/skpi/storage/framework/app/cache \
    && mkdir -p /var/www/html/skpi/storage/framework/sessions \
    && mkdir -p /var/www/html/skpi/storage/framework/views \
    && mkdir -p /var/www/html/skpi/storage/logs \
    && mkdir -p /var/www/html/skpi/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html/skpi \
    && find /var/www/html/skpi -type d -exec chmod 755 {} \; \
    && find /var/www/html/skpi -type f -exec chmod 644 {} \; \
    && chmod -R 775 /var/www/html/skpi/storage \
    && chmod -R 775 /var/www/html/skpi/bootstrap/cache

# Optimasi PHP-FPM
RUN echo "upload_max_filesize = 100M" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/uploads.ini

EXPOSE 9000

CMD ["php-fpm"]