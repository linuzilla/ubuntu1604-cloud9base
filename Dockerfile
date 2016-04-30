FROM ubuntu:16.04
MAINTAINER Mac Liu <linuzilla@gmail.com>

RUN apt-get update && \
	apt-get install -y build-essential g++ \
		curl libssl-dev apache2-utils \
		git libxml2-dev sshfs \
		supervisor nodejs tmux; \
	groupadd -r cloud9 && \
	useradd -r -g cloud9 cloud9 -d /cloud9 -s /bin/bash; \
	mkdir /cloud9; chmod 2775 /cloud9; chown cloud9:cloud9 /cloud9

RUN git clone https://github.com/c9/core.git /c9sdk
WORKDIR /c9sdk
RUN umask 002; \
	HOME=/cloud9 ./scripts/install-sdk.sh; \
	sed -i -e 's/127.0.0.1/0.0.0.0/g' /cloud9/configs/standalone.js; \
	mkdir /workspace; \
	apt-get autoremove --purge -y \
		build-essential \
		g++ gcc libssl-dev apache2-utils; \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY files/supervisord.conf /etc/supervisor/
COPY files/cloud9.conf /etc/supervisor/conf.d/

# ENV C9USERID 1000
VOLUME [ "/workspace" ]

EXPOSE 8181

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
