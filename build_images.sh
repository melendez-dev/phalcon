#!/bin/bash

IMAGE_NAME="wilmendoza/phalcon"
ARCH=(amd64 arm64)

for a in ${ARCH[@]}; do
    if [[ $a == "arm64" ]]; then
        IMAGE_NAME="$IMAGE_NAME-arm64"
    fi

    docker build --platform linux/$a --build-arg  PHALCON_VERSION=4.0.x --build-arg PHP_VERSION=7.4 -t $IMAGE_NAME .
    docker tag $IMAGE_NAME $IMAGE_NAME:latest
    docker push $IMAGE_NAME:latest

    docker build --platform linux/$a --build-arg  PHALCON_VERSION=3.4.x --build-arg PHP_VERSION=7.2 -t $IMAGE_NAME:3.4 .
    docker tag $IMAGE_NAME:3.4 $IMAGE_NAME:3.4-$a
    docker push $IMAGE_NAME:3.4-$a

done
