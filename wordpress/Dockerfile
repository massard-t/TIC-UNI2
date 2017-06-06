FROM wordpress:4.7.5-apache

MAINTAINER Theo Massard <massar_t@etna-alternance.net>

COPY install.sh /
USER root
RUN curl -o /usr/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
      && chmod +x /install.sh && /install.sh

RUN ls /
USER 

