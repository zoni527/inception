#!/bin/ash
admin_user="$(cat /run/secrets/wordpress_admin)"
admin_password="$(cat /run/secrets/wordpress_admin_password)"
admin_email="$(cat /run/secrets/wordpress_admin_email)"
title=${WORDPRESS_SITE_TITLE:-Inception}
domain=${DOMAIN_NAME:-localhost}
port=${NGINX_PORT_HOST:-443}

if [ "${port}" = "443" ]; then
	url="https://${domain}"
else
	url="https://${domain}:${port}"
fi

dbname=${MARIADB_DATABASE_NAME:-wordpress}
dbuser="$(cat /run/secrets/mariadb_user)"
dbpass="$(cat /run/secrets/mariadb_user_password)"
dbhost=${DATABASE_HOSTNAME:-mariadb}:${MARIADB_PORT_INTERNAL:-3306}

wordpress_user="$(cat /run/secrets/wordpress_user)"
wordpress_user_email="$(cat /run/secrets/wordpress_user_email)"
wordpress_user_password="$(cat /run/secrets/wordpress_user_password)"

mkdir -p /var/log/fpm-php

if [ ! -f ./wp-config.php ]; then
	wp config create \
		--dbname=${dbname} \
		--dbuser=${dbuser} \
		--dbpass=${dbpass} \
		--dbhost=${dbhost} \
		--allow-root
else
	# Force change DB_HOST in case of port and/or hostname change between runs
	sed -i "s/define( 'DB_HOST', .*/define( 'DB_HOST', '${dbhost}' );/" wp-config.php
fi

echo "Waiting for MariaDB to be available on ${dbhost}"
count=0
while ! nc -z ${DATABASE_HOSTNAME:-mariadb} ${MARIADB_PORT_INTERNAL:-3306}; do
	echo "Waiting..."
	sleep 2
	count=$(expr $count + 1)
	if [ "${count}" = "30" ]; then
		echo "Couldn't reach MariaDB"
		exit 1
	fi
done
echo "MariaDB available"

if ! wp core is-installed --allow-root; then
	wp core install \
		--admin_user=${admin_user} \
		--admin_password=${admin_password} \
		--admin_email=${admin_email} --skip-email \
		--title="${title}" \
		--url=${url} \
		--allow-root

	wp user create \
		${wordpress_user} ${wordpress_user_email} \
		--user_pass=${wordpress_user_password} \
		--role=${WORDPRESS_USER_ROLE:-author} \
		--allow-root
fi

# Updates done always in case of .env changes
wp option update siteurl "${url}" --allow-root
wp option update home "${url}" --allow-root
wp option update blogname "${title}" --allow-root

envsubst '${WORDPRESS_PORT_INTERNAL}' \
	< /etc/php83/php-fpm.d/www.conf.template > /etc/php83/php-fpm.d/www.conf && \
	chmod 644 /etc/php83/php-fpm.d/www.conf

chown -R www-data:www-data .

exec php-fpm83 -F
