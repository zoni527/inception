FROM alpine:3.22

WORKDIR /app

RUN apk update && apk add --no-cache nginx envsubst openssl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf.template
COPY ./tools/nginx_entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx_entrypoint.sh

EXPOSE ${NGINX_PORT_INTERNAL}

ENTRYPOINT ["/usr/local/bin/nginx_entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
