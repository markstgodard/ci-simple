#!/bin/bash
set -e

cd app-src

echo "Linting..."

php-cs-fixer fix . --verbose --dry-run
