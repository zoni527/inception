# Penultimate stable alpine image as base
FROM alpine:3.21
WORKDIR /usr/share/webapps

# Get WordPress dependencies
RUN apk update && apk add php fcgi php-cgi wget;

RUN wget https://wordpress.org/latest.tar.gz && tar -xzvf latest.tar.gz && rm latest.tar.gz;
