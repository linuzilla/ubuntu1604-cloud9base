FROM ubuntu:16.04
MAINTAINER Mac Liu <linuzilla@gmail.com>

RUN apt-get update && apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs supervisor nodejs tmux

RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN ./scripts/install-sdk.sh

RUN sed -i -e 's/127.0.0.1/0.0.0.0/g' /cloud9/configs/standalone.js 

ADD files/cloud9.conf /etc/supervisor/conf.d/

RUN mkdir /workspace
VOLUME /workspace

RUN apt-get autoremove --purge -y build-essential g++ gcc libssl-dev apache2-utils; apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8181

CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisord.conf"]
