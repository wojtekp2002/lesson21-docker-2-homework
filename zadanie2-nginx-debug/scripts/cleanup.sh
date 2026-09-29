#!/usr/bin/env bash
set -euo pipefail

docker rm -f lesson21-nginx-debug >/dev/null 2>&1 || true

if [ "${REMOVE_VOLUMES:-0}" = "1" ]; then
  docker volume rm lesson21_nginx_logs >/dev/null 2>&1 || true
fi
