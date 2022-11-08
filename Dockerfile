FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-lancache-prefill"

RUN apt-get update && \
	apt-get -y install --no-install-recommends unzip jq cron && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/lancacheprefill"
ENV ENABLE_BN="true"
ENV ENABLE_STEAM="true"
ENV UPDATES="true"
ENV FORCE_UPDATE="true"
ENV LOGCLEANUP="true"
ENV CRON_SCHED_BN="0 5 * * *"
ENV CRON_SCHED_STEAM="0 2 * * *"
ENV PREFILL_PARAMS_BN="prefill --products s1 d3 wow_classic"
ENV PREFILL_PARAMS_STEAM="prefill --recent"
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