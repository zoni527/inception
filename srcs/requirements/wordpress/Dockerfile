# Penultimate stable alpine image as base
FROM alpine:3.22
WORKDIR /app

# Get WordPress dependencies
RUN apk update && \
	apk add --no-cache \
		php83 \
		php83-phar \
		php83-mysqli \
		wget

RUN wget https://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz && \
	mv wordpress/* . && \
	rm -rf wordpress latest.tar.gz && \
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp && \
	apk del wget

COPY ./tools/wp_cli_install.sh .

RUN chmod +x ./wp_cli_install.sh && ./wp_cli_install.sh
