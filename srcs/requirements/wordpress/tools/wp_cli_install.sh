#!/bin/sh

dbname=wordpress
admin_user=bob
admin_password=adminpwd
admin_email=admin@site.fi
title="jvarila's inception wordpress site"
domain=jvarila.42.fr
port=443

dbname=wordpress
dbuser=mysql
dbpass=mysqlpwd
dbhost=mariadb

wp config create \
	--dbname=${dbname} \
	--dbuser=${dbuser} \
	--dbpass=${dbpass} \
	--dbhost=${dbhost}

wp core install \
	--admin_user=${admin_user} \
	--admin_password=${admin_password} \
	--admin_email=${admin_email} --skip-email \
	--title="${title}" \
	--url=https://${domain}:${port}  \
	--allow-root
