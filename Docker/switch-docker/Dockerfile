FROM ubuntu:18.04
# sudo docker build -t switch-docker:latest switch-docker
USER root
ENV HOME /root
WORKDIR /root

MAINTAINER Subhrendu Chattopadhyay <subhrendu@iitg.ac.in>
#ENV http_proxy 'http://172.16.117.50:4128'
#ENV https_proxy 'http://172.16.117.50:4128'
#ENV ftp_proxy 'http://172.16.117.50:4128'



COPY ENTRYPOINT.sh /

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    sysstat \
    bmon \
    sshpass \
    rsync \
    curl \
    ethtool \
    iproute2 \
    iputils-ping \
    mininet \
    net-tools \
    openvswitch-switch \
    openvswitch-testcontroller \
    tcpdump \
    vim \
    x11-xserver-utils \
    xterm \
    docker \
 && rm -rf /var/lib/apt/lists/* \
 && chmod +x /ENTRYPOINT.sh


RUN apt-get update && apt-get install -y openssh-server
RUN mkdir ~/.ssh
RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
RUN echo $(cat ~/.ssh/id_rsa.pub) >> ~/.ssh/authorized_keys
RUN echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvdRWXkj90+6d4m5cF+R49CloRndaCwwpJvsJgn/fnn1eWhxBTlcMgaOou2J5H2vPJdKFty6/J5gKFDBSNCkZ4kfuaTyJw41WxsBP0BMbM+ydlCOieYp8iWfKO3h1nfYyv7NZWj0jQkCNmRcz+awdx1ABqLLMt84H4WC64+4ImZkYHonIP22h41nPusM2oXjObFUpbDuJreAZcf+szk0mEkCqUsCn4fNu9clumfeiwJEdEoAPprdicQcMI8foq5QQodcCINcTYBpWqaBF/C6siQH8Hd/jSW9QyDOUYOCi6++nRi/TiZXsXi8WGvbNmb4Oq1yAIb19F6hbCvgHQasK1 rishabh@rishabh-VirtualBox >> ~/.ssh/authorized_keys
#RUN echo $(cat ~/.ssh/id_rsa.pub) >> home/rishabh/.ssh/authorized_keys
RUN mkdir /var/run/sshd
RUN echo 'root:Rishabh@515' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN  echo "IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config
RUN  echo "StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
##################################################################################
## In host folder
# DOCKER_CHANNEL=stable && DOCKER_VERSION=18.09.6 && dockerArch=x86_64
# wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"
##################################################################################
ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 18.09.8
ENV dockerArch x86_64

#RUN apt-get update && apt-get install -y --no-install-recommends wget
#RUN wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"

COPY docker.tgz /root

RUN	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	\
	dockerd --version; \
	docker --version



EXPOSE 6633 6653 6640

#ENTRYPOINT ["/ENTRYPOINT.sh"]
