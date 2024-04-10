FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-nzbhydra2"

RUN apt-get update && \
	mkdir -p /usr/share/man/man1 && \
	apt-get -y install --no-install-recommends openjdk-17-jre unzip python3 python3-pip netcat-traditional && \
	APPRISE_V=$(wget -qO- https://api.github.com/repos/caronc/apprise/releases/latest | grep "tag_name" | cut -d '"' -f4 | tr -d v) && \
	pip install apprise==${APPRISE_V} --break-system-packages && \
	apt-get -y remove python3-pip && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/nzbhydra2"
ENV NZBHYDRA2_REL="latest"
ENV START_PARAMS=""
ENV CONNECTED_CONTAINERS=""
ENV UMASK=0000
ENV DATA_PERM=770
ENV UID=99
ENV GID=100
ENV USER="nzbhydra2"

RUN mkdir $DATA_DIR && \
	mkdir /mnt/downloads && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chmod -R 770 /mnt && \
	chown -R $UID:$GID /mnt

EXPOSE 5076

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]