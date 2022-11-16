#!/bin/bash
# Export terminal
export TERM=xterm-mono

# Check if at least one prefil method is enabled
if [ "${ENABLE_BN}" != "true" ] && [ "${ENABLE_STEAM}" != "true" ]; then
  echo "---No prefill selected, please enable at least one and restart the container!---"
  sleep infinity
fi

# Battle Net routine and update check
if [ "${ENABLE_BN}" == "true" ]; then
  cd ${DATA_DIR}
  echo "---BattleNetPrefill enabled!---"
  if [ ! -f ${DATA_DIR}/BattleNetPrefill/BattleNetPrefill ]; then
    echo "---BattleNetPrefill not found, downloading and installing, please wait!---"
    BN_LAT_V="$(wget -qO- https://api.github.com/repos/tpill90/battlenet-lancache-prefill/releases/latest | jq -r '.tag_name')"
    if [ -z "${BN_LAT_V}" ]; then
      echo "-----Something went wrong while getting the latest version!-----"
      echo "---Please try again later, putting container into sleep mode!---"
      sleep infinity
    fi
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/BNPrefill.zip "https://github.com/tpill90/battlenet-lancache-prefill/releases/download/${BN_LAT_V}/BattleNetPrefill-${BN_LAT_V//v}-linux-x64.zip" ; then
        echo "---Sucessfully downloaded BattleNetPrefill ${BN_LAT_V}---"
    else
      echo "---Something went wrong, can't download BattleNetPrefill ${BN_LAT_V}, putting container in sleep mode---"
      rm -f ${DATA_DIR}/BNPrefill.zip
      sleep infinity
    fi
    mkdir -p ${DATA_DIR}/BattleNetPrefill
    rm -rf /tmp/bnprefill
    unzip ${DATA_DIR}/BNPrefill.zip -d /tmp/bnprefill
    mv $(find /tmp/bnprefill -type f) ${DATA_DIR}/BattleNetPrefill/BattleNetPrefill
    chmod +x ${DATA_DIR}/BattleNetPrefill/BattleNetPrefill
    rm -rf ${DATA_DIR}/BNPrefill.zip /tmp/bnprefill
    touch ${DATA_DIR}/bnprefill_${BN_LAT_V}
  else
    BN_CUR_V="$(find ${DATA_DIR}/ -maxdepth 1 -type f -name "bnprefill_*" | cut -d '_' -f2)"
    if [ "${UPDATES}" == "true" ]; then
      echo "---Version Check!---"
      BN_LAT_V="$(wget -qO- https://api.github.com/repos/tpill90/battlenet-lancache-prefill/releases/latest | jq -r '.tag_name')"
      if [ -z "${BN_LAT_V}" ]; then
        echo "---Can't get latest version from BattleNetPrefill, falling back to installed ${BN_CUR_V}---"
        BN_LAT_V="${BN_CUR_V}"
      fi
      if [ "${BN_CUR_V}" != "${BN_LAT_V}" ]; then
        echo "---Version missmatch, installed ${BN_CUR_V}, downloading and installing latest ${BN_LAT_V}...---"
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/BNPrefill.zip "https://github.com/tpill90/battlenet-lancache-prefill/releases/download/${BN_LAT_V}/BattleNetPrefill-${BN_LAT_V//v}-linux-x64.zip" ; then
          echo "---Sucessfully downloaded BattleNetPrefill ${BN_LAT_V}---"
        else
          echo "---Something went wrong, can't download BattleNetPrefill ${BN_LAT_V}, putting container in sleep mode---"
          rm -f ${DATA_DIR}/BNPrefill.zip
          sleep infinity
        fi
        mkdir -p ${DATA_DIR}/BattleNetPrefill
        rm -rf /tmp/bnprefill ${DATA_DIR}/bnprefill_*
        unzip ${DATA_DIR}/BNPrefill.zip -d /tmp/bnprefill
        mv $(find /tmp/bnprefill -type f -name "BattleNetPrefill*") ${DATA_DIR}/BattleNetPrefill/BattleNetPrefill
        chmod +x ${DATA_DIR}/BattleNetPrefill/BattleNetPrefill
        rm -rf ${DATA_DIR}/BNPrefill.zip /tmp/bnprefill
        touch ${DATA_DIR}/bnprefill_${BN_LAT_V}
      elif [ "${BN_CUR_V}" == "${BN_LAT_V}" ]; then
        echo "---BattleNetPrefill ${BN_CUR_V} up-to-date---"
      fi
    else
      echo "---Update check disabled, found installed version ${BN_CUR_V}---"
    fi
  fi
fi

# Steam routine and update check
if [ "${ENABLE_STEAM}" == "true" ]; then
  cd ${DATA_DIR}
  echo "---SteamPrefill enabled!---"
  if [ ! -f ${DATA_DIR}/SteamPrefill/SteamPrefill ]; then
    echo "---SteamPrefill not found, downloading and installing, please wait!---"
    STEAM_LAT_V="$(wget -qO- https://api.github.com/repos/tpill90/steam-lancache-prefill/releases/latest | jq -r '.tag_name')"
    if [ -z "${STEAM_LAT_V}" ]; then
      echo "-----Something went wrong while getting the latest version!-----"
      echo "---Please try again later, putting container into sleep mode!---"
      sleep infinity
    fi
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/STEAMPrefill.zip "https://github.com/tpill90/steam-lancache-prefill/releases/download/${STEAM_LAT_V}/SteamPrefill-${STEAM_LAT_V//v}-linux-x64.zip" ; then
        echo "---Sucessfully downloaded SteamPrefill ${STEAM_LAT_V}---"
    else
      echo "---Something went wrong, can't download SteamPrefill ${STEAM_LAT_V}, putting container in sleep mode---"
      rm -f ${DATA_DIR}/STEAMPrefill.zip
      sleep infinity
    fi
    mkdir -p ${DATA_DIR}/SteamPrefill
    rm -rf /tmp/steamprefill
    unzip ${DATA_DIR}/STEAMPrefill.zip -d /tmp/steamprefill
    mv $(find /tmp/steamprefill -type f -name "SteamPrefill*") ${DATA_DIR}/SteamPrefill/SteamPrefill
    chmod +x ${DATA_DIR}/SteamPrefill/SteamPrefill
    rm -rf ${DATA_DIR}/STEAMPrefill.zip /tmp/steamprefill
    touch ${DATA_DIR}/steamprefill_${STEAM_LAT_V}
  else
    STEAM_CUR_V="$(find ${DATA_DIR}/ -maxdepth 1 -type f -name "steamprefill_*" | cut -d '_' -f2)"
    if [ "${UPDATES}" == "true" ]; then
      echo "---Version Check!---"
      STEAM_LAT_V="$(wget -qO- https://api.github.com/repos/tpill90/steam-lancache-prefill/releases/latest | jq -r '.tag_name')"
      if [ -z "${STEAM_LAT_V}" ]; then
        echo "---Can't get latest version from SteamPrefill, falling back to installed ${BN_CUR_V}---"
        STEAM_LAT_V="${STEAM_CUR_V}"
      fi
      if [ "${STEAM_CUR_V}" != "${STEAM_LAT_V}" ]; then
        echo "---Version missmatch, installed ${STEAM_CUR_V}, downloading and installing latest ${STEAM_LAT_V}...---"
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/STEAMPrefill.zip "https://github.com/tpill90/steam-lancache-prefill/releases/download/${STEAM_LAT_V}/SteamPrefill-${STEAM_LAT_V//v}-linux-x64.zip" ; then
          echo "---Sucessfully downloaded SteamPrefill ${STEAM_LAT_V}---"
        else
          echo "---Something went wrong, can't download SteamPrefill ${STEAM_LAT_V}, putting container in sleep mode---"
          rm -f ${DATA_DIR}/STEAMPrefill.zip
          sleep infinity
        fi
        mkdir -p ${DATA_DIR}/SteamPrefill
        rm -rf /tmp/steamprefill ${DATA_DIR}/steamprefill_*
        unzip ${DATA_DIR}/STEAMPrefill.zip -d /tmp/steamprefill
        mv $(find /tmp/steamprefill -type f -name "SteamPrefill*") ${DATA_DIR}/SteamPrefill/SteamPrefill
        chmod +x ${DATA_DIR}/SteamPrefill/SteamPrefill
        rm -rf ${DATA_DIR}/STEAMPrefill.zip /tmp/steamprefill
        touch ${DATA_DIR}/steamprefill_${STEAM_LAT_V}
      elif [ "${STEAM_CUR_V}" == "${STEAM_LAT_V}" ]; then
        echo "---SteamPrefill ${STEAM_CUR_V} up-to-date---"
      fi
    else
      echo "---Update check disabled, found installed version ${STEAM_CUR_V}---"
    fi
  fi
fi

echo "---Prepare Server---"
chmod -R ${DATA_PERM} ${DATA_DIR}

# Remove old way of creating crontab
if [ -f ${DATA_DIR}/cron ]; then
  rm -rf ${DATA_DIR}/cron
fi

# Create logs dir if non exists
if [ ! -d ${DATA_DIR}/logs ]; then
  mkdir -p ${DATA_DIR}/logs
fi

# Check if logcleanup is enabled
if [ "${LOGCLEANUP}" == "true" ]; then
   rm -f ${DATA_DIR}/logs/*
fi

# Check if Steam is enabled and already configured or not
if [ "${ENABLE_STEAM}" == "true" ]; then
  if [ ! -f ${DATA_DIR}/SteamPrefill/Config/account.config ]; then
    STEAM_NO_CONFIG="true"
    echo "+-----------------------------------------------------------------------+"
    echo "| ATTENTION - ATTENTION - ATTENTION - ATTENTION - ATTENTION - ATTENTION |"
    echo "|                                                                       |"
    echo "| Steam Prefill not configured, to configure it please do the following:|"
    echo "| 1. Open up a container console                                        |"
    echo "| 2. Type in 'su \$USER' (case sensitive!) and press ENTER               |"
    echo "| 3. Type in 'cd \${DATA_DIR}/SteamPrefill' and press ENTER              |"
    echo "| 4. Type in './SteamPrefill select-apps' and press ENTER               |"
    echo "| 5. Enter your Steam credentials and follow the steps displayed        |"
    echo "| 6. Select the apps you want to prefill (you don't have to select any) |"
    echo "| 7. Done                                                               |"
    echo "|                                                                       |"
    echo "| ATTENTION - ATTENTION - ATTENTION - ATTENTION - ATTENTION - ATTENTION |"
    echo "+-----------------------------------------------------------------------+"
  else
    STEAM_NO_CONFIG="false"
  fi
fi

# Check if force update on container start/restart is enabled and execute prefill
if [ "${FORCE_UPDATE}" == "true" ]; then
  crontab -r 2>/dev/null
  echo "---Force update enabled!---"
  if [ "${ENABLE_BN}" == "true" ]; then
    echo "[$(date +%F)] Starting BattleNetPrefill"
    ${DATA_DIR}/BattleNetPrefill/BattleNetPrefill prefill ${PREFILL_PARAMS_BN}
  fi
  if [ "${ENABLE_STEAM}" == "true" ]; then
    if [ "${STEAM_NO_CONFIG}" != "true" ]; then
      echo "[$(date +%F)] Starting SteamPrefill"
      ${DATA_DIR}/SteamPrefill/SteamPrefill prefill --no-ansi ${PREFILL_PARAMS_STEAM}
    fi
  fi
fi

# Set up cron schedules
if [ ! -z "${CRON_SCHED_GLOBAL}" ]; then
  echo "${CRON_SCHED_GLOBAL} /opt/cron/global_schedule.sh" > /tmp/cron
else
  rm -f /tmp/cron
  if [ "${ENABLE_BN}" == "true" ]; then
     echo "${CRON_SCHED_BN} /opt/cron/battlenet_schedule.sh" > /tmp/cron
  fi
  if [ "${ENABLE_STEAM}" == "true" ]; then
    if [ "${STEAM_NO_CONFIG}" != "true" ]; then
      echo "${STEAM_NO_CONFIG} /opt/cron/steam_schedule.sh" >> /tmp/cron
    fi
  fi
fi

# Set up tail follow
if [ "${ENABLE_BN}" == "true" ]; then
 touch ${DATA_DIR}/logs/battlenet_prefill.log
 TAIL_FOLLOW="${DATA_DIR}/logs/battlenet_prefill.log"
fi
if [ "${ENABLE_STEAM}" == "true" ]; then
  if [ "${STEAM_NO_CONFIG}" != "true" ]; then
    touch ${DATA_DIR}/logs/steam_prefill.log
    if [ -z "${TAIL_FOLLOW}" ]; then
      TAIL_FOLLOW="${DATA_DIR}/logs/steam_prefill.log"
    else
      TAIL_FOLLOW="$TAIL_FOLLOW -f ${DATA_DIR}/logs/steam_prefill.log"
    fi
  fi
fi

# Set up crontab and list cron
crontab /tmp/cron 2>/dev/null || { \
  echo; \
  echo "+---------------------------------------------------------------+"; \
  echo "| CRON - ATTENTION - CRON - ATTENTION - CRON - ATTENTION - CRON |"; \
  echo "|                                                               |"; \
  echo "|    Setting up cron job failed, please check your schedule     |"; \
  echo "|                   and make sure it's valid!                   |"; \
  echo "|                                                               |"; \
  echo "|      Visit https://crontab.guru to check your schedule!       |"; \
  echo "|                                                               |"; \
  echo "| CRON - ATTENTION - CRON - ATTENTION - CRON - ATTENTION - CRON |"; \
  echo "+---------------------------------------------------------------+"; }

echo
if [ ! -z "${CRON_SCHED_GLOBAL}" ]; then
  echo "Your global defined cron schedule is: ${CRON_SCHED_GLOBAL}"
else
  if [ "${ENABLE_BN}" == "true" ]; then
    echo "Your cron schedule for BattleNetPrefill is: ${CRON_SCHED_BN}"
  fi
  if [ "${ENABLE_STEAM}" == "true" ]; then
    if [ "${STEAM_NO_CONFIG}" != "true" ]; then
        echo "Your cron schedule for SteamPrefill is: ${CRON_SCHED_STEAM}"
    fi
  fi
fi

echo
echo "---Container fully started, waiting for next cron job to start!---"
echo

# Follow log files
tail -f ${TAIL_FOLLOW}