FROM alpine:3.22

WORKDIR /app

# WordPress dependencies
RUN apk update && apk add --no-cache \
	php83 \
	php83-phar \
	php83-mysqli \
	php83-fpm \
	php83-mbstring \
	php83-dom \
	php83-gd \
	php83-zip \
	php83-curl \
	wget

# WordPress files and client (php archive) from tarball
RUN wget https://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz && \
	mv wordpress/* . && \
	rm -rf wordpress latest.tar.gz && \
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp && \
	apk del wget

# Config for php FastCGI Process Manager
COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

# -H: no home, -D: no password, -s: login shell, -G: add group also
RUN adduser -H -D -s /sbin/nologin -G www-data www-data

COPY ./tools/wp_cli_install.sh .
RUN chmod +x ./wp_cli_install.sh

ARG WORDPRESS_PORT_INTERNAL=9000

EXPOSE ${WORDPRESS_PORT_INTERNAL}

ENTRYPOINT ["./wp_cli_install.sh"]
