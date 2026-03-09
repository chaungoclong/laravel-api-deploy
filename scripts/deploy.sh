#!/bin/bash
echo ">>> Starting deployment script"

# Enable debugging: print each command before executing it
set -xeuo pipefail

# Log both stdout and stderr to a file for debugging (overwrite file each run)
LOG_FILE="/tmp/deploy.log"
exec > >(tee "$LOG_FILE") 2>&1

CURRENT_USER=$(whoami)
WEB_USER="nginx" # AMI Amazon Linux 2023 default web user
echo ">>> Current user: $CURRENT_USER"

APP_DIR="/var/www/laravel"

sudo chown -R $CURRENT_USER:$WEB_USER $APP_DIR

cd $APP_DIR

# Install PHP dependencies
composer install --no-dev --optimize-autoloader

# Ensure .env exists
cp .env.dev .env
# Generate Laravel key if not exists
php artisan key:generate || true

# Run migrations
php artisan migrate --force

# Clear old caches
php artisan optimize:clear

# Permissions for writable dirs
sudo chown -R $CURRENT_USER:$WEB_USER $APP_DIR/storage $APP_DIR/bootstrap/cache
sudo chmod -R 775 $APP_DIR/storage $APP_DIR/bootstrap/cache

sudo systemctl restart php-fpm.service
sudo systemctl restart nginx.service
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart all

echo ">>> Deployment script finished"
