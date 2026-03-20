FROM alpine:3.22

WORKDIR /app

ENV user=mysql
ENV datadir=/var/lib/mysql
ENV logdir=/var/log/mysql
ENV log_error=${logdir}/mariadb.err

RUN apk update && apk add --no-cache mariadb mariadb-client
COPY ./tools/mariadb_entrypoint.sh .
RUN chmod +x mariadb_entrypoint.sh

ARG MYSQL_TCP_PORT=3306
EXPOSE ${MYSQL_TCP_PORT}

ENTRYPOINT ["./mariadb_entrypoint.sh"]
