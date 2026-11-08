#!/bin/sh

set -eu

: "${DB_NAME:?}"
: "${DB_USER:?}"
: "${DB_HOST:?}"
: "${DOMAIN_NAME:?}"
: "${WP_SITE_TITLE:?}"
: "${WP_ADMIN_USER:?}"
: "${WP_ADMIN_EMAIL:?}"
: "${WP_USER_NAME:?}"
: "${WP_USER_EMAIL:?}"

if [ ! -f /var/www/html/wp-includes/version.php ]; then
    echo "Initializing WordPress files..."
    cp -a /usr/src/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

install -o root -g www-data -m 0640 \
    /usr/src/wordpress/wp-config.php \
    /var/www/html/wp-config.php

install -d -o root -g www-data -m 0750 /run/wordpress

install -o root -g www-data -m 0440 \
    /run/secrets/db_password \
    /run/wordpress/db_password

install -o root -g www-data -m 0440 \
    /run/secrets/wp_salts \
    /run/wordpress/wp_salts.php

i=0
until php -r '
    mysqli_report(MYSQLI_REPORT_OFF);
    $db = @new mysqli(
        getenv("DB_HOST"),
        getenv("DB_USER"),
        trim(file_get_contents("/run/wordpress/db_password")),
        getenv("DB_NAME")
    );
    exit($db->connect_errno ? 1 : 0);
' >/dev/null 2>&1; do
    i=$((i + 1))
    if [ "$i" -ge 30 ]; then
        echo "MariaDB is not ready" >&2
        exit 1
    fi
    sleep 1
done

if ! runuser -u www-data -- wp --quiet --path=/var/www/html core is-installed; then
    echo "Installing WordPress..."

    runuser -u www-data -- wp --quiet --path=/var/www/html core install \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_SITE_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --prompt=admin_password < /run/secrets/wp_admin_password

    echo "WordPress installed."
fi

if ! runuser -u www-data -- wp --quiet --path=/var/www/html user get "$WP_USER_NAME" --field=ID >/dev/null 2>&1; then
    echo "Creating WordPress subscriber..."

    runuser -u www-data -- wp --quiet --path=/var/www/html user create \
        "$WP_USER_NAME" \
        "$WP_USER_EMAIL" \
        --role=subscriber \
        --prompt=user_pass < /run/secrets/wp_user_password

    echo "WordPress subscriber created."
fi

exec php-fpm8.2 -F
