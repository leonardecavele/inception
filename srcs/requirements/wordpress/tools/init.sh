#!/bin/sh

set -eu

if [ ! -f /var/www/html/wp-includes/version.php ]; then
    echo "Initializing WordPress files..."
    cp -a /usr/src/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

exec php-fpm8.2 -F
