#!/bin/bash
if [ "${ENABLE_BN}" == "true" ]; then
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
        mv $(find /tmp/bnprefill -type f) ${DATA_DIR}/BattleNetPrefill/BattleNetPrefill
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




     

sleep infinity