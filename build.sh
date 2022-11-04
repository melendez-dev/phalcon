#!/bin/bash
PHALCON_VERSION=3.4.x
PHP_VERSION=7.2


docker build --build-arg PHP_VERSION=$PHP_VERSION --build-arg PHALCON_VERSION=$PHALCON_VERSION -t phalcon_test .