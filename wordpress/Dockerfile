FROM wordpress:4.7.5-apache

MAINTAINER Theo Massard <massar_t@etna-alternance.net>

COPY install.sh /
USER root

ENV DOCKERIZE_RELEASE v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz
RUN curl -sL https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_RELEASE} \
  | tar -C /usr/bin -xzvf -

RUN apt-get update -y \
    && apt-get install -y mysql-client
ENTRYPOINT /install.sh


