FROM debian:12

RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server && \
    rm -rf /var/lib/apt/lists/*

RUN install -d -o mysql -g mysql -m 0755 /run/mysqld

COPY conf/99-inception.cnf /etc/mysql/mariadb.conf.d/99-inception.cnf

CMD ["mariadbd", "--user=mysql"]
