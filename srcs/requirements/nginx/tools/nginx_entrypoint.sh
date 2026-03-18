#!/bin/ash
set -e

if [ ! -d /etc/nginx/ssl ]; then
	mkdir -p /etc/nginx/ssl
else
	rm -rf /etc/nginx/ssl/*
fi

openssl req -x509 -newkey rsa:4096 -noenc 2>/dev/null \
	-keyout	/etc/nginx/ssl/private.key \
	-out	/etc/nginx/ssl/public.crt \
	-days	3650 \
	-subj	"/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN_NAME:-localhost}"

envsubst \
		'${FRONTEND_HOSTNAME} \
		${DOMAIN_NAME} \
		${NGINX_PORT_INTERNAL} \
		${WORDPRESS_PORT_INTERNAL}' \
	< /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && \
	chmod 644 /etc/nginx/nginx.conf

exec "$@"
