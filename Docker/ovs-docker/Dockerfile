# Ryu SDN Framework
#https://hub.docker.com/r/osrg/ryu/dockerfile
# VERSION 0.0.1

#FROM ubuntu:16.04

#MAINTAINER FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

#ENV HOME /root
#WORKDIR /root

#RUN apt-get update && apt-get install -y --no-install-recommends \
#    curl \
#    python-setuptools \
#    python-pip \
#    python-eventlet \
#    python-lxml \
#    python-msgpack \
#    iproute2 \
# && rm -rf /var/lib/apt/lists/* \
# && curl -kL https://github.com/osrg/ryu/archive/master.tar.gz | tar -xvz \
# && mv ryu-master ryu \
# && cd ryu \
# && pip install -r tools/pip-requires \
# && python setup.py install

#	ryu-manager --observe-links --ofp-tcp-listen-port 6600 --wsapi-port 9100 ryu.app.ofctl_rest ryu.app.simple_switch_13
#	sudo docker run -t -i --name <ctlr_name> ryu-docker /bin/bash -p 6600:<ofp_port> -p 9100:<wsgi_port>

###########################################################################################################################################
FROM ubuntu:latest

ENV HOME /root
WORKDIR /root
#ENV http_proxy 'http://172.16.117.50:4128'
#ENV https_proxy 'http://172.16.117.50:4128'
#ENV ftp_proxy 'http://172.16.117.50:4128'

RUN apt-get update
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends python-setuptools
RUN apt-get install -y --no-install-recommends python-pip
RUN apt-get install -y --no-install-recommends python-eventlet
RUN apt-get install -y --no-install-recommends python-lxml
RUN apt-get install -y --no-install-recommends python-msgpack
RUN apt-get install -y --no-install-recommends iproute2
RUN apt-get install -y --no-install-recommends openssl
RUN apt-get install -y --no-install-recommends ca-certificates
RUN apt-get install -y --no-install-recommends kmod
RUN apt-get install -y --no-install-recommends iptables
RUN apt-get install -y --no-install-recommends bridge-utils
RUN apt-get install -y --no-install-recommends openvswitch-switch openvswitch-common
#RUN apt-get install -y --no-install-recommends supervisor
RUN mkdir -p /var/run/openvswitch/
RUN ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema
RUN touch /var/run/openvswitch/db.sock

RUN rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
###########################################################################################
#RUN apt-get install -y --no-install-recommends git
#RUN apt-get install -y --no-install-recommends autoconf libtool make

#RUN git clone https://github.com/openvswitch/ovs.git

#mkdir -p /usr/local/var/run/openvswitch/
#RUN cd /usr/local/share/openvswitch/scripts/ && 

#RUN mkdir -p /var/run/openvswitch/
#RUN touch /var/run/openvswitch/db.sock
#RUN cd /usr/local/share/openvswitch/scripts/
#ENTRYPOINT ["ovsdb-server", \
#    "--remote=ptcp:6640", \
#    "--remote=db:Open_vSwitch,Open_vSwitch,manager_options", \
#    "--log-file=/var/log/openvswitch/ovsdb-server.log", \
#    "--pidfile", "/etc/openvswitch/conf.db", "/etc/openvswitch/ovnnb.db", \
#    "/etc/openvswitch/ovnsb.db"]

#ovsdb-server --remote=ptcp:6640 --remote=db:Open_vSwitch,Open_vSwitch,manager_options --log-file=/var/log/openvswitch/ovsdb-server.log --pidfile /etc/openvswitch/conf.db /etc/openvswitch/ovnnb.db /etc/openvswitch/ovnsb.db
###########################################################################################
#ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf 
#COPY start-ovs-service.sh start-ovs-service.sh

ENTRYPOINT service openvswitch-switch start && /bin/bash
