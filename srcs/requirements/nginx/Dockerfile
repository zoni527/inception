FROM alpine:3.22

WORKDIR /app

ARG FRONTEND_HOSTNAME=wordpress
ARG DOMAIN_NAME=localhost
ARG NGINX_PORT_INTERNAL=443
ARG WORDPRESS_PORT_INTERNAL=9000

RUN apk update && apk add --no-cache nginx envsubst openssl

COPY ./conf/nginx.conf .

RUN envsubst \
		'${FRONTEND_HOSTNAME} \
		${DOMAIN_NAME} \
		${NGINX_PORT_INTERNAL} \
		${WORDPRESS_PORT_INTERNAL}' \
	< nginx.conf > /etc/nginx/nginx.conf && \
	rm nginx.conf && \
	apk del envsubst

RUN mkdir -p /etc/nginx/ssl && \
	openssl	req -x509 -newkey rsa:4096 -noenc 2>/dev/null \
	-keyout	/etc/nginx/ssl/private.key \
	-out	/etc/nginx/ssl/public.crt \
	-days	3650 \
	-subj	"/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN_NAME}"

RUN chown -R nginx:www-data .

EXPOSE ${NGINX_PORT_INTERNAL}

ENTRYPOINT ["nginx", "-g", "daemon off;"]
