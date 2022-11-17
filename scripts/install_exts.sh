#!/bin/bash

EXTS=(pdo pdo_mysql pdo_pgsql gd psr)

for EXT in ${EXTS[@]}; do
    docker-php-ext-install $EXT

    if [[ $EXT != "gd" ]]; then
        docker-php-ext-enable $EXT
    fi
done
