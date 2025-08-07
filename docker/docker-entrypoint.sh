#!/bin/bash
service cron start
chown -R 1001:1002 /app || true
exec gosu 1001:1002 /app/start.sh
