# Penultimate stable alpine image as base
FROM alpine:3.22

WORKDIR /mariadb

RUN apk update && apk add --no-cache mariadb mariadb-client
COPY ./tools/mariadb_install.sh .
RUN chmod +x ./mariadb_install.sh

CMD ["./mariadb_install.sh"]
