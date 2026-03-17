#!/bin/ash
set -e

envsubst \
		'${FRONTEND_HOSTNAME} \
		${DOMAIN_NAME} \
		${NGINX_PORT_INTERNAL} \
		${WORDPRESS_PORT_INTERNAL}' \
	< /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && \
	chmod 644 /etc/nginx/nginx.conf

exec "$@"
