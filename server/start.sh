#!/bin/bash

id

steamcmd=${STEAM_HOME}/steamcmd/steamcmd.sh

ACTUAL_PORT=${PORT:-8211}
ARGS="${ARGS} -port=${ACTUAL_PORT} -publicport=${ACTUAL_PORT}"

if [ -n "${PLAYERS}" ]; then
    ARGS="${ARGS} -players=${PLAYERS}"
fi
if [ -n "${SERVER_NAME}" ]; then
    ARGS="${ARGS} -servername=${SERVER_NAME}"
fi
if [ -n "${SERVER_PASSWORD}" ]; then
    ARGS="${ARGS} -serverpassword=${SERVER_PASSWORD}"
fi
if [ -z "${NO_MULTITHREADING}" ]; then
    ARGS="${ARGS} -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
fi

# advertise server
ARGS="${ARGS} EpicApp=PalServer"

PalServerDir=/app/PalServer
mkdir -p ${PalServerDir}

# Conditionally apply chown if running as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Running as root, applying chown and crontab..."
    chown -R ${PUID:-1001}:${PGID:-1002} /app || echo "chown failed, continuing anyway"
    crontab /app/crontab || echo "crontab failed, continuing anyway"
else
    echo "Not running as root, skipping chown and crontab"
fi

set -x
$steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir ${PalServerDir} +login anonymous +app_update ${APPID} validate +quit
set +x

PalServerExe="${PalServerDir}/Pal/Binaries/Win64/PalServer-Win64-Shipping.exe"
if [ ! -f ${PalServerExe} ]; then
    echo "${PalServerExe} does not exist"
    exit 1
fi

CMD="$PROTON run $PalServerExe ${ARGS}"
echo "starting server with: ${CMD}"
${CMD}
