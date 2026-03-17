FROM alpine:3.22

RUN apk update && apk add --no-cache nginx envsubst openssl

# Create SSL self signed certificate
ARG DOMAIN_NAME=localhost
RUN mkdir -p /etc/nginx/ssl && \
	openssl	req -x509 -newkey rsa:4096 -noenc 2>/dev/null \
	-keyout	/etc/nginx/ssl/private.key \
	-out	/etc/nginx/ssl/public.crt \
	-days	3650 \
	-subj	"/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN_NAME}"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf.template
COPY ./tools/nginx_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx_entrypoint.sh

EXPOSE ${NGINX_PORT_INTERNAL}

ENTRYPOINT ["/usr/local/bin/nginx_entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
