#!/bin/ash
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

wordpress_user=harry
wordpress_user_email=potter@hogwarts.uk
wordpress_user_password=imawizard

if [ ! -f /app/wp-config.php ]; then
	wp config create \
		--dbname=${dbname} \
		--dbuser=${dbuser} \
		--dbpass=${dbpass} \
		--dbhost=${dbhost} \
		--allow-root

	wp core install \
		--admin_user=${admin_user} \
		--admin_password=${admin_password} \
		--admin_email=${admin_email} --skip-email \
		--title="${title}" \
		--url=https://${domain}:${port} \
		--allow-root

	wp user create \
		${wordpress_user} ${wordpress_user_email} \
		--user_pass=${wordpress_user_password} \
		--allow-root

	chown -R www-data:www-data /app
fi

exec php-fpm83 -F
