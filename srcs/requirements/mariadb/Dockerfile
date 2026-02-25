# Penultimate stable alpine image as base
FROM alpine:3.22
WORKDIR /mariadb
# Get MariaDB using Alpine Package Keeper
RUN apk update && apk add --no-cache mariadb mariadb-client

CMD ["./tools/mariadb_install.sh"]
