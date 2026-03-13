FROM alpine:3.22

WORKDIR /app

ENV NGINX_PORT_INTERNAL 443
ENV WORDPRESS_PORT_INTERNAL 9000
ENV DOMAIN_NAME jvarila.42.fr

RUN apk update && apk add --no-cache nginx envsubst openssl

COPY ./conf/nginx.conf .

RUN envsubst '${DOMAIN_NAME} ${NGINX_PORT_INTERNAL} ${WORDPRESS_PORT_INTERNAL}' \
	< nginx.conf > /etc/nginx/nginx.conf && \
	rm nginx.conf && \
	apk del envsubst

RUN mkdir -p /etc/nginx/ssl && \
	openssl	req -x509 -newkey rsa:4096 -noenc 2>/dev/null \
	-keyout	/etc/nginx/ssl/private.key \
	-out	/etc/nginx/ssl/public.crt \
	-days	3650 \
	-subj	"/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN_NAME}"

EXPOSE ${NGINX_PORT_INTERNAL}

ENTRYPOINT ["nginx", "-g", "daemon off;"]
