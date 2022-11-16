#!/bin/bash
. /opt/cron/env.sh
if [ "${ENABLE_STEAM}" == "true" ]; then
  if [ "$(pidof SteamPrefill)" ]; then
    echo "[$(date +%F)] SteamPrefill already running, aborting schedule!" >> ${DATA_DIR}/logs/steam_prefill.log
  else
    echo "[$(date +%F)] Starting SteamPrefill" >> ${DATA_DIR}/logs/steam_prefill.log
    ${DATA_DIR}/SteamPrefill/SteamPrefill prefill --no-ansi ${PREFILL_PARAMS_STEAM} >> ${DATA_DIR}/logs/steam_prefill.log
  fi
fi