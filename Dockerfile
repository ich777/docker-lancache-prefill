FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-lancache-prefill"

RUN apt-get update && \
	apt-get -y install --no-install-recommends unzip jq cron && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/lancacheprefill"
ENV ENABLE_BN="false"
ENV ENABLE_EPIC="false"
ENV ENABLE_STEAM="true"
ENV UPDATES="true"
ENV PREFILL_ONSTARTUP="false"
ENV FORCE_UPDATE="false"
ENV LOGCLEANUP="true"
ENV CRON_SCHED_BN="0 5 * * *"
ENV CRON_SCHED_EPIC="0 4 * * *"
ENV CRON_SCHED_STEAM="0 2 * * *"
ENV CRON_SCHED_GLOBAL=""
ENV PREFILL_PARAMS_BN="--products s1 d3 wow_classic"
ENV PREFILL_PARAMS_EPIC=""
ENV PREFILL_PARAMS_STEAM="--recent"
ENV UMASK=0000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="prefill"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

RUN echo "#Custom motd message for Docker container" >> /etc/bash.bashrc && \
	echo "[ ! -z \"\$TERM\" -a -r /etc/motd ] && cat /etc/docker.motd" >> /etc/bash.bashrc

ADD /scripts/ /opt/scripts/
ADD /cron/ /opt/cron/
ADD /docker.motd /etc/docker.motd
RUN chmod -R 777 /opt/scripts/
RUN chmod -R 777 /opt/cron/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]
