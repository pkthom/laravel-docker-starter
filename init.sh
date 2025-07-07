#!/bin/bash

set -e

# Create Laravel project if it doesn't exist
if [ ! -f ./laravel/artisan ]; then
  echo "Creating Laravel project..."
  mkdir -p laravel
  docker run --rm -v $(pwd)/laravel:/app composer create-project laravel/laravel .
fi

# Update .env DB settings
echo "Updating .env DB settings..."
sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=mysql/' ./laravel/.env
sed -i 's/^DB_HOST=.*/DB_HOST=db/' ./laravel/.env
sed -i 's/^DB_PORT=.*/DB_PORT=3306/' ./laravel/.env
sed -i 's/^DB_DATABASE=.*/DB_DATABASE=laravel/' ./laravel/.env
sed -i 's/^DB_USERNAME=.*/DB_USERNAME=laravel/' ./laravel/.env
sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=secret/' ./laravel/.env

# Generate Laravel app key (safe to run multiple times)
docker compose run --rm app php artisan key:generate

# Start and build containers
docker compose up -d --build

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
until docker compose exec db mysql -ularavel -psecret -e "SELECT 1;" >/dev/null 2>&1; do
  sleep 1
done

# Fix permissions
docker compose exec app chmod -R 777 storage bootstrap/cache

# Run migrations
docker compose exec app php artisan migrate

