FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-battlnet-lancache-prefill"

RUN apt-get update && \
	apt-get -y install --no-install-recommends unzip jq && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/bn-prefill"
ENV CRON_SCHED="0 5 * * *"
ENV PREFILL_PARAMS="prefill --products s1 d3 wow_classic"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="prefill"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 777 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]