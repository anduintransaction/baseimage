#!/bin/bash
set -e
source /build/buildconfig
set -x

# install java8:
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections; apt-get -y install oracle-java8-installer

# set java8 default:
apt-get install oracle-java8-set-default

# set JAVA_HOME
echo "/usr/lib/jvm/java-8-oracle" > /etc/container_environment/JAVA_HOME

# secured SecureRandom
sed -e 's%^\(securerandom.source\)=.*%\1=file:/dev/./urandom%' \
        -i /usr/lib/jvm/java-8-oracle/jre/lib/security/java.security
