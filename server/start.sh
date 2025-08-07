#!/bin/bash

die() {
    echo "$0 script failed, hanging forever..."
    while [ 1 ]; do sleep 10;done
    # exit 1
}

id

steamcmd=${STEAM_HOME}/steamcmd/steamcmd.sh

ACTUAL_PORT=8211
if [ "${PORT}" != "" ];then
    ACTUAL_PORT=${PORT}
fi
ARGS="${ARGS} -port=${ACTUAL_PORT} -publicport=${ACTUAL_PORT}"

if [ "${PLAYERS}" != "" ];then
    ARGS="${ARGS} -players=${PLAYERS}"
fi
if [ "${SERVER_NAME}" != "" ];then
    ARGS="${ARGS} -servername=${SERVER_NAME}"
fi
if [ "${SERVER_PASSWORD}" != "" ];then
    ARGS="${ARGS} -serverpassword=${SERVER_PASSWORD}"
fi
if [ "${SERVER_PASSWORD}" != "" ];then
    ARGS="${ARGS} -serverpassword=${SERVER_PASSWORD}"
fi
if [ "${NO_MULTITHREADING}" ]; then
    ARGS=${ARGS}
else
    ARGS="${ARGS} -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
fi 

# advertise server
ARGS="${ARGS} EpicApp=PalServer"

PalServerDir=/app/PalServer

mkdir -p ${PalServerDir}

set -x
$steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir ${PalServerDir} +login anonymous +app_update ${APPID} validate +quit || die
set +x


PalServerExe="${PalServerDir}/Pal/Binaries/Win64/PalServer-Win64-Shipping.exe"
if [ ! -f ${PalServerExe} ];then
    echo "${PalServerExe} does not exist"
    die
fi

# 루트일 때만 crontab과 chown 실행
if [ "$(id -u)" -eq 0 ]; then
    echo "Running as root, applying crontab and chown..."
    crontab /app/crontab || echo "crontab failed, continuing anyway"
    chown -R 1001:1002 /app || echo "chown failed, continuing anyway"
else
    echo "Not running as root, skipping crontab and chown"
fi

CMD="$PROTON run $PalServerExe ${ARGS}"
echo "starting server with: ${CMD}"
${CMD} || die
