#!/bin/bash
set -e

cd app-src

echo "Install dependencies..."
composer install --dev --no-progress --no-interaction

echo "Running unit tests..."
./vendor/bin/phpunit
