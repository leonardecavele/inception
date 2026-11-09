FROM debian:12

RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nginx/sites-enabled/default

COPY conf/inception.conf /etc/nginx/conf.d/inception.conf

CMD ["nginx", "-g", "daemon off;"]
