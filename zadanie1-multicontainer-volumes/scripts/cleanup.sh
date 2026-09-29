#!/usr/bin/env bash
set -euo pipefail

docker rm -f lesson21-web lesson21-db >/dev/null 2>&1 || true
docker network rm lesson21_app_net >/dev/null 2>&1 || true

if [ "${REMOVE_VOLUMES:-0}" = "1" ]; then
  docker volume rm lesson21_pgdata lesson21_static >/dev/null 2>&1 || true
fi
