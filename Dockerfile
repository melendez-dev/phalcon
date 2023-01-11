
ARG PHP_VERSION

FROM php:${PHP_VERSION}-apache

MAINTAINER  wilson.mendoza@bodytechcorp.com

ARG PHALCON_VERSION
ARG IP

RUN a2enmod rewrite

RUN apt update && apt install -y git libpq-dev libpng-dev zip unzip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY ./scripts/* /tmp

RUN chmod +x /tmp/*.sh
RUN /tmp/install_phalcon.sh ${PHALCON_VERSION}
RUN /tmp/install_exts.sh

RUN echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini

# install xdebug
RUN pecl install xdebug-2.9.0
RUN docker-php-ext-enable xdebug
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# relevant to this answer
RUN echo "xdebug.idekey="VSCODE"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_host="${IP} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.start_with_request=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_host="${IP} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
ENV WEB_DOCUMENT_ROOT=/var/www/html/

WORKDIR /var/www/html
