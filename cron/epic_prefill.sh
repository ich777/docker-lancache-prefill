#!/bin/bash
. /opt/cron/env.sh
if [ "${ENABLE_EPIC}" == "true" ]; then
  if [ "$(pidof EpicPrefill)" ]; then
    echo "[$(date +%F)] EpicPrefill already running, aborting schedule!" >> ${DATA_DIR}/logs/epic_prefill.log
  else
    echo "[$(date +%F)] Starting EpicPrefill" >> ${DATA_DIR}/logs/epic_prefill.log
    ${DATA_DIR}/EpicPrefill/EpicPrefill prefill --no-ansi ${PREFILL_PARAMS_EPIC} >> ${DATA_DIR}/logs/epic_prefill.log
  fi
fi