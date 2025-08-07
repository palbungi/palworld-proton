#!/bin/bash
set -e

# Print current user and group info
echo "Running as UID=$(id -u), GID=$(id -g)"

# Load environment variables from default.env if present
if [ -f "/app/default.env" ]; then
    echo "Loading environment variables from /app/default.env"
    export $(grep -v '^#' /app/default.env | xargs)
fi

# Set default values if not provided
PUID=${PUID:-1001}
PGID=${PGID:-1002}
TZ=${TZ:-UTC}

# Apply timezone
echo "Setting timezone to $TZ"
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Create user and group if running as root
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
