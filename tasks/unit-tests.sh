#!/bin/bash
set -e

echo "Running unit tests"
php -v

echo "Install dependencies..."
composer install --dev --no-progress --no-interaction

echo "Running unit tests..."
./vendor/bin/phpunit
