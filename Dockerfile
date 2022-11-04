
ARG PHP_VERSION

FROM php:${PHP_VERSION}-apache

MAINTAINER  wilson.mendoza@bodytechcorp.com

ARG PHALCON_VERSION

RUN a2enmod rewrite

RUN apt update && apt install -y git libpq-dev libpng-dev zip unzip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY ./scripts/* /tmp

RUN chmod +x /tmp/*.sh
RUN /tmp/install_phalcon.sh ${PHALCON_VERSION}
RUN /tmp/install_exts.sh

RUN echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini

WORKDIR /var/www/html