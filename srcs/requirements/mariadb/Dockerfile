# Penultimate stable alpine image as base
FROM alpine:3.22

WORKDIR /app

ENV user=mysql
ENV datadir=/var/lib/mysql
ENV logdir=/var/log/mysql
ENV log_error=${logdir}/mariadb.err

RUN apk update && apk add --no-cache mariadb mariadb-client
COPY ./tools/mariadb_install.sh .
RUN chmod +x ./mariadb_install.sh && ./mariadb_install.sh

ENV MYSQL_TCP_PORT=3306
EXPOSE ${MYSQL_TCP_PORT}

ENTRYPOINT exec mariadbd-safe \
	--user=${user} \
	--datadir=${datadir} \
	--log_error=${log_error} \
	--port=${MYSQL_TCP_PORT}\
	--bind-address=0.0.0.0 \
	--skip-networking=false
