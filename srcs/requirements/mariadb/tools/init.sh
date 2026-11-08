#!/bin/sh

set -eu

: "${DB_NAME:?DB_NAME is missing}"
: "${DB_USER:?DB_USER is missing}"

case "$DB_NAME" in
    ''|*[!a-zA-Z0-9_]*)
        echo "Invalid database name" >&2
        exit 1
        ;;
esac

case "$DB_USER" in
    ''|*[!a-zA-Z0-9_]*)
        echo "Invalid database username" >&2
        exit 1
        ;;
esac

DB_PASSWORD=$(cat /run/secrets/db_password)

case "$DB_PASSWORD" in
    ''|*[!0-9a-f]*)
        echo "Invalid database password format" >&2
        exit 1
        ;;
esac

install -d -o mysql -g mysql -m 0755 /run/mysqld

mariadbd --user=mysql --skip-networking &
server_pid=$!

i=0
until mariadb --protocol=socket -u root -e "SELECT 1" >/dev/null 2>&1; do
    i=$((i + 1))
    if [ "$i" -ge 30 ]; then
        echo "MariaDB failed to start" >&2
        exit 1
    fi
    sleep 1
done

mariadb --protocol=socket -u root <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
SQL

mariadb-admin --protocol=socket -u root shutdown
wait "$server_pid"

exec mariadbd --user=mysql
