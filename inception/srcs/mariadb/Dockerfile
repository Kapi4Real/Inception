FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client bash && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld
COPY ./conf/99-bind.cnf /etc/mysql/mariadb.conf.d/99-bind.cnf
COPY ./tools/init.sql /tmp/init.sql
COPY ./tools/init.sh /tmp/init.sh
RUN chmod +x /tmp/init.sh
EXPOSE 3306
CMD ["/tmp/init.sh"]
