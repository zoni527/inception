#!/bin/ash
admin_user="$(cat /run/secrets/wordpress_admin)"
admin_password="$(cat /run/secrets/wordpress_admin_password)"
admin_email="$(cat /run/secrets/wordpress_admin_email)"
title=${WORDPRESS_SITE_TITLE:-Inception}
domain=${DOMAIN_NAME:-localhost}
port=${WORDPRESS_PORT_INTERNAL:-9000}

dbname=${MARIADB_DATABASE_NAME:-wordpress}
dbuser="$(cat /run/secrets/mariadb_user)"
dbpass="$(cat /run/secrets/mariadb_user_password)"
dbhost=${DATABASE_HOSTNAME:-mariadb}:${MARIADB_PORT_INTERNAL:-9000}

wordpress_user="$(cat /run/secrets/wordpress_user)"
wordpress_user_email="$(cat /run/secrets/wordpress_user_email)"
wordpress_user_password="$(cat /run/secrets/wordpress_user_password)"

if [ ! -f ./wp-config.php ]; then
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

	chown -R www-data:www-data .
fi

exec php-fpm83 -F
