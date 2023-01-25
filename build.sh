#!/bin/bash
PHALCON_VERSION=4.0.x
PHP_VERSION=7.4

docker build --build-arg PHP_VERSION=$PHP_VERSION --build-arg PHALCON_VERSION=$PHALCON_VERSION -t phalcon:latest .
