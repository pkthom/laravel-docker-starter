# Laravel Docker Starter

A minimal Laravel development environment using Docker.  
Includes PHP-FPM, Nginx, and MySQL.

## Requirements

- Docker
- Docker Compose  
  Install using:  
  https://github.com/pkthom/install-docker-compose-ubuntu

## Usage

```bash
chmod +x init.sh
./init.sh
```

This will:
- Create a Laravel project (if not exists)
- Update .env for MySQL connection
- Generate the application key
- Build and start containers
- Set file permissions
- Run database migrations

## Services
- app: PHP 8.2 (FPM)
- web: Nginx
- db: MySQL 8.0

## Access
- Laravel: http://localhost:8000
- MySQL: localhost:3306

## Cleanup
```
docker compose down -v
```
