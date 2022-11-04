#!/bin/bash

cd /tmp
git clone https://github.com/phalcon/cphalcon.git -b $1 && \
cd /tmp/cphalcon/build
./install
rm -rf /tmp/cphalcon
