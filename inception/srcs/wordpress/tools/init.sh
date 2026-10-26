#!/bin/bash
set -e

# Wait for MariaDB to accept connections. Use the configured app user if available,
# otherwise keep waiting until the server is up and users are created by the DB init.
echo "Waiting for MariaDB..."
until mysql -h mariadb -u "${DB_USER}" -p"${DB_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; do
  sleep 2
done

cd /var/www/html

# If WordPress is not present, download it. If files are already present on the
# mounted volume, don't fail — only download when `index.php` is missing.
if [ ! -f wp-config.php ]; then
  if [ ! -f index.php ]; then
    wp core download --allow-root
  fi

  # Create config if missing. Ignore errors if config already exists.
  wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASSWORD}" --dbhost="mariadb:3306" --allow-root --quiet || true

  # Install WordPress only if not already installed
  if ! wp core is-installed --allow-root >/dev/null 2>&1; then
    wp core install --url="${WP_URL}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_ADMIN_EMAIL}" --allow-root --quiet
  fi
fi

chown -R www-data:www-data /var/www/html
mkdir -p /run/php

# Run php-fpm in foreground
php-fpm7.4 -F
