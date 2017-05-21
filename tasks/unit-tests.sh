#!/bin/bash
set -e

echo "Running unit tests"
php -v

wget https://getcomposer.org/installer
mv composer.phar /usr/local/bin/composer

echo "Install dependencies..."
composer install --dev --no-progress --no-interaction

echo "Running unit tests..."
./vendor/bin/phpunit
