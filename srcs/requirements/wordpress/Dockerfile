FROM debian:12

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip && \
    rm -rf /var/lib/apt/lists/*

ARG WP_VERSION=7.1.4

RUN mkdir -p /usr/src/wordpress && \
    curl -fSL "https://wordpress.org/wordpress-${WP_VERSION}.tar.gz" -o /tmp/wordpress.tar.gz && \
    tar -xzf /tmp/wordpress.tar.gz -C /usr/src/wordpress --strip-components=1 && \
    rm /tmp/wordpress.tar.gz

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY conf/wp-config.php /usr/src/wordpress/wp-config.php
COPY tools/init.sh /usr/local/bin/init-wordpress

RUN install -d -m 0755 /run/php && \
    chmod 755 /usr/local/bin/init-wordpress

ENTRYPOINT ["/usr/local/bin/init-wordpress"]
