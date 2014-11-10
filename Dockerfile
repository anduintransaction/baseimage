FROM phusion/baseimage:0.9.15
MAINTAINER Binh Nguyen "binhnguyen@anduintransact.com"

# avoid interactive dialouges from apt:
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN echo Anduin Base Docker Image > /etc/container_environment/IMAGE_TYPE

# add repos and update:
RUN add-apt-repository ppa:webupd8team/java; apt-get update; apt-get -y dist-upgrade

# install java8:
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections; apt-get -y install oracle-java8-installer

# set java8 default:
RUN apt-get install oracle-java8-set-default

# set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# secured SecureRandom
RUN sed -e 's%^\(securerandom.source\)=.*%\1=file:/dev/./urandom%' \
        -i $JAVA_HOME/jre/lib/security/java.security

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
