#!/bin/bash
# cron 실행 (실패해도 계속 진행)
service cron start || echo "cron failed to start"
# chown 실패 무시
chown -R 1001:1002 /app || echo "chown failed, continuing anyway"
# UID:GID 1001:1002로 start.sh 실행
exec gosu 1001:1002 /app/start.sh
