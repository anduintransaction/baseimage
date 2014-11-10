FROM ubuntu:14.10
MAINTAINER Binh Nguyen "binhnguyen@anduintransact.com"

# avoid interactive dialouges from apt:
ENV DEBIAN_FRONTEND noninteractive

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list

# add repos and update:
RUN add-apt-repository ppa:webupd8team/java; apt-get update; apt-get -y dist-upgrade

# install java8:
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections; apt-get -y install oracle-java8-installer

RUN apt-get update && apt-get install -yq \
    make \
    ca-certificates \
    net-tools \
    sudo \
    wget \
    vim \
    strace \
    lsof \
    netcat \
    software-properties-common \
    python-software-properties \
    python-pip \
    curl \
    oracle-java8-set-default \
    supervisor \
    --no-install-recommends

# install etcd
RUN mkdir /tmp/etcd
RUN curl --silent https://api.github.com/repos/coreos/etcd/releases | grep -v beta | grep -v alpha | sed -n 's|.*\"tag_name\": \"\(.*\)\".*|\1|p' | head -n 1 > /tmp/etcd_version
RUN curl -L https://github.com/coreos/etcd/releases/download/`cat /tmp/etcd_version`/etcd-`cat /tmp/etcd_version`-linux-amd64.tar.gz | tar -xz --directory /tmp/etcd --strip-components 1
RUN cp /tmp/etcd/etcd /usr/local/bin/ && cp /tmp/etcd/etcdctl /usr/local/bin/
RUN rm -rf /tmp/etcd

# set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# secured SecureRandom
RUN sed -e 's%^\(securerandom.source\)=.*%\1=file:/dev/./urandom%' \
        -i $JAVA_HOME/jre/lib/security/java.security

EXPOSE 4001 7001

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD config/supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
