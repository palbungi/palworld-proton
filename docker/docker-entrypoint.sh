#!/bin/bash
set -e

echo "Running as UID=$(id -u), GID=$(id -g)"

if [ -f "/app/default.env" ]; then
    echo "Loading environment variables from /app/default.env"
    export $(grep -v '^#' /app/default.env | xargs)
fi

PUID=${PUID:-1001}
PGID=${PGID:-1002}

# 루트일 때만 사용자 생성 및 권한 변경
if [ "$(id -u)" -eq 0 ]; then
    echo "Creating user with UID=$PUID and GID=$PGID"
    groupadd -g $PGID palgroup || true
    useradd -u $PUID -g $PGID -m paluser || true
    chown -R $PUID:$PGID /app
    exec gosu $PUID:$PGID /app/start.sh
else
    echo "Not running as root, executing start.sh directly"
    exec /app/start.sh
fi
