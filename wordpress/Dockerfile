FROM wordpress:4.7.5-apache

MAINTAINER Theo Massard <massar_t@etna-alternance.net>

RUN curl -o /bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
            && chmod +x /bin/wp

ENV DOCKERIZE_RELEASE v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz
RUN curl -sL https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_RELEASE} \
  | tar -C /usr/bin -xzvf -

RUN apt-get clean \
            && rm -rf /var/lib/apt/lists/* \
            /tmp/* \
            /var/tmp/*

EXPOSE 80
EXPOSE 443

ADD install.sh /
CMD ["/install.sh"]

#COPY install.sh /
#USER root
#
#ENV DOCKERIZE_RELEASE v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz
#RUN curl -sL https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_RELEASE} \
#  | tar -C /usr/bin -xzvf -
#
#RUN apt-get update -y \
#    && apt-get install -y mysql-client
#ENTRYPOINT /install.sh


