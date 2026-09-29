#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

docker rm -f lesson21-web lesson21-db >/dev/null 2>&1 || true
docker network create lesson21_app_net >/dev/null 2>&1 || true
docker volume create lesson21_pgdata >/dev/null
docker volume create lesson21_static >/dev/null

docker run --rm -v lesson21_static:/static alpine sh -c 'echo "Plik zapisany w named volume lesson21_static" > /static/note.txt'

docker build -t lesson21-webapp:v1 webapp

docker run -d \
  --name lesson21-db \
  --network lesson21_app_net \
  --network-alias lesson21-db \
  --restart unless-stopped \
  -e POSTGRES_DB=lesson21 \
  -e POSTGRES_USER=lesson21 \
  -e POSTGRES_PASSWORD=lesson21pass \
  -v lesson21_pgdata:/var/lib/postgresql/data \
  postgres:16-alpine

for attempt in $(seq 1 40); do
  if docker exec lesson21-db pg_isready -U lesson21 -d lesson21 >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

docker run -d \
  --name lesson21-web \
  --network lesson21_app_net \
  --restart unless-stopped \
  -p 8081:5000 \
  -e DB_HOST=lesson21-db \
  -e DB_NAME=lesson21 \
  -e DB_USER=lesson21 \
  -e DB_PASSWORD=lesson21pass \
  -v lesson21_static:/app/static-volume:ro \
  lesson21-webapp:v1

docker ps --filter name=lesson21 --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}'
