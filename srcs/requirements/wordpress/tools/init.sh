#!/bin/sh

set -eu

if [ ! -f /var/www/html/wp-includes/version.php ]; then
    echo "Initializing WordPress files..."
    cp -a /usr/src/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

if [ ! -f /var/www/html/wp-config.php ]; then
    cp /usr/src/wordpress/wp-config.php /var/www/html/wp-config.php
    chown www-data:www-data /var/www/html/wp-config.php
    chmod 640 /var/www/html/wp-config.php
fi

install -d -o root -g www-data -m 0750 /run/wordpress
install -o root -g www-data -m 0440 /run/secrets/db_password /run/wordpress/db_password

exec php-fpm8.2 -F
