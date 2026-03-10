#!/bin/sh

admin_user=bob
admin_password=adminpwd
admin_email=admin@site.fi
title="jvarila's inception wordpress site"
domain=localhost
port=9000

dbname=wordpress
dbuser=wp_user
dbpass=userpwd
dbhost=mariadb:3306

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
	--url=https://${domain}:${port} \
	--allow-root
