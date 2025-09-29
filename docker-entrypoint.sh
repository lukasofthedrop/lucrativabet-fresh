#!/bin/bash
set -e

echo "=== Laravel Application Initialization ==="

# Wait for a moment to ensure the environment is ready
sleep 2

# Create .env file if it doesn't exist
if [ ! -f /app/.env ]; then
    echo "Creating .env file from .env.example..."
    cp /app/.env.example /app/.env
else
    echo ".env file already exists"
fi

# Generate application key if not present
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:" ]; then
    echo "Generating application key..."
    php artisan key:generate --force --no-interaction
else
    echo "Application key already set"
fi

# Set up view cache directory for Railway
export VIEW_COMPILED_PATH="${VIEW_COMPILED_PATH:-/tmp/views}"
mkdir -p $VIEW_COMPILED_PATH
chown -R www-data:www-data $VIEW_COMPILED_PATH
chmod -R 755 $VIEW_COMPILED_PATH

# Run migrations if enabled
if [ "$RUN_MIGRATIONS" = "1" ]; then
    echo "Running database migrations..."
    php artisan migrate --force
fi

# Cache configuration for better performance
echo "Caching configuration..."
php artisan config:cache

# Cache routes for better performance
echo "Caching routes..."
php artisan route:cache

# Cache views for better performance
echo "Caching views..."
php artisan view:cache

# Clear any existing cache that might be stale
echo "Clearing application cache..."
php artisan cache:clear

# Ensure storage and bootstrap/cache are writable
echo "Setting permissions..."
chown -R www-data:www-data /app/storage /app/bootstrap/cache
chmod -R 755 /app/storage /app/bootstrap/cache

# Create storage link
echo "Creating storage link..."
php artisan storage:link

echo "=== Initialization complete. Starting services ==="

# Execute the original command (start supervisord)
exec /usr/bin/supervisord -c /app/docker/supervisord.conf