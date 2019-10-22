FROM ubuntu:16.04
# sudo docker build -t ryu-docker:latest ryu-docker
MAINTAINER Subhrendu Chattopadhyay <subhrendu@iitg.ac.in>
#ENV http_proxy 'http://172.16.117.50:4128'
#ENV https_proxy 'http://172.16.117.50:4128'
#ENV ftp_proxy 'http://172.16.117.50:4128'

EXPOSE 6600 9100
ENV HOME /root
WORKDIR /root


ENV HOME /root
WORKDIR /root

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    python-setuptools \
    python-pip \
    python-eventlet \
    python-lxml \
    python-msgpack \
    iproute2
RUN apt-get install -y --no-install-recommends net-tools \
	telnet\
	inetutils*
RUN cd /mnt && curl -kL https://github.com/osrg/ryu/archive/master.tar.gz | tar -xvz
RUN mv /mnt/ryu-master /mnt/ryu
RUN ln -s /mnt/ryu
RUN cd ryu && pip install -r /mnt/ryu/tools/pip-requires
RUN rm -rf /var/lib/apt/lists/* \
RUN && cd ryu \
	&& pip install -r tools/pip-requires
#RUN mv /mnt/ryu /mnt/ryu.old
#CMD ["sh","-c","cd /Shared; ryu/bin/ryu-manager --observe-links --ofp-tcp-listen-port 6600 --wsapi-port 9100 ryu.app.ofctl_rest ryu.app.simple_switch_rest_13"]
