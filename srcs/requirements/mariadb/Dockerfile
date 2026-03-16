FROM alpine:3.22

WORKDIR /app

# The MYSQL_TCP_PORT is defined here as an environment variable just in case.
# It is an environment variable often referenced by database software, but I
# also explicitly set it as the --port option value when starting the mariadb
# daemon process.
ARG MYSQL_TCP_PORT=3306
ENV MYSQL_TCP_PORT=${MYSQL_TCP_PORT}
EXPOSE ${MYSQL_TCP_PORT}

ENV user=mysql
ENV datadir=/var/lib/mysql
ENV logdir=/var/log/mysql
ENV log_error=${logdir}/mariadb.err

RUN apk update && apk add --no-cache mariadb mariadb-client
COPY ./tools/mariadb_install.sh .
RUN chmod +x ./mariadb_install.sh

ENTRYPOINT ["./mariadb_install.sh"]
