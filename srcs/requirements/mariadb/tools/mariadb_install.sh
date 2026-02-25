#!/bin/sh

# Environment variable controlling the port that is used for
# connecting to mariadb
export MYSQL_TCP_PORT=$MARIADB_PORT_INTERNAL

mariadb-install-db --user=mysql --basedir=/usr
mariadbd --user=mysql
