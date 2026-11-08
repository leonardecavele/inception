FROM debian:12

RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY conf/99-inception.cnf /etc/mysql/mariadb.conf.d/99-inception.cnf
COPY tools/init.sh /usr/local/bin/init-mariadb

RUN chmod 755 /usr/local/bin/init-mariadb

ENTRYPOINT ["/usr/local/bin/init-mariadb"]
