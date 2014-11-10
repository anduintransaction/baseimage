#!/bin/bash
set -e
source /build/buildconfig
set -x

add-apt-repository ppa:webupd8team/java

apt-get update
