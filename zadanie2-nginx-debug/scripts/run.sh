#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

docker rm -f lesson21-nginx-debug >/dev/null 2>&1 || true
docker volume create lesson21_nginx_logs >/dev/null

docker run -d \
  --name lesson21-nginx-debug \
  --restart on-failure:3 \
  --log-driver json-file \
  --log-opt max-size=1m \
  --log-opt max-file=3 \
  -p 8082:80 \
  -v "$PWD/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  -v "$PWD/html:/usr/share/nginx/html:ro" \
  -v lesson21_nginx_logs:/host-logs \
  nginx:alpine

for attempt in $(seq 1 20); do
  if curl -fsS http://localhost:8082/ >/dev/null; then
    break
  fi
  sleep 1
done

docker ps --filter name=lesson21-nginx-debug --format 'table {{.Names}}\t{{.Ports}}\t{{.Status}}'
