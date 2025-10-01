# Use PHP 8.2 FPM as base
FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    wget \
    git \
    unzip \
    zip \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    libzip-dev \
    libintl \
    icu-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    freetype-dev

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    gd \
    pdo_mysql \
    mysqli \
    bcmath \
    intl \
    zip \
    opcache \
    xml \
    simplexml \
    curl \
    mbstring \
    tokenizer

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js and npm
RUN apk add --no-cache nodejs npm

# Set working directory
WORKDIR /app

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /app

# Install PHP dependencies
RUN composer install --no-dev --prefer-dist --no-interaction --no-progress --optimize-autoloader

# Install Node.js dependencies and build assets
RUN npm ci && npm run build

# Set permissions
RUN chown -R www-data:www-data /app \
    && chmod -R 755 /app/storage \
    && chmod -R 755 /app/bootstrap/cache

# Copy configuration files
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose port
EXPOSE 80

# Set entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
