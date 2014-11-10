FROM phusion/baseimage:0.9.15
MAINTAINER Binh Nguyen "binhnguyen@anduintransact.com"

ENV HOME /root

RUN mkdir /build

ADD ./build /build

RUN /build/install.sh

CMD ["/sbin/my_init"]
