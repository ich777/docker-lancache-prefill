#!/bin/bash
. /opt/cron/env.sh
if [ "${ENABLE_BN}" == "true" ]; then
  if [ "$(pidof BattleNetPrefill)" ]; then
    echo "[$(date +%F)] BattleNetPrefill already running, aborting schedule!" >> ${DATA_DIR}/logs/battlenet_prefill.log
  else
    echo "[$(date +%F)] Starting BattleNetPrefill" >> ${DATA_DIR}/logs/battlenet_prefill.log
    ${DATA_DIR}/BattleNetPrefill/BattleNetPrefill prefill --no-ansi >> ${DATA_DIR}/logs/battlenet_prefill.log
  fi
fi