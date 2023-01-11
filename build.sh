#!/bin/bash
PHALCON_VERSION=3.4.x
PHP_VERSION=7.2
IP=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')

docker build --build-arg IP=$IP --build-arg PHP_VERSION=$PHP_VERSION --build-arg PHALCON_VERSION=$PHALCON_VERSION -t phalcon:3.4-xdebug .
