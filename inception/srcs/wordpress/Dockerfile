FROM debian:bullseye

RUN apt-get update && apt-get install -y \
  php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip \
  mariadb-client wget curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && cd /var/www/html && \
  wget https://wordpress.org/latest.tar.gz && tar -xzf latest.tar.gz && mv wordpress/* . && rm -rf wordpress latest.tar.gz && chown -R www-data:www-data /var/www/html

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/init.sh /tmp/init.sh
RUN chmod +x /tmp/init.sh
EXPOSE 9000
CMD ["/tmp/init.sh"]
