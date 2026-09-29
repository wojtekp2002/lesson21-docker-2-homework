#!/usr/bin/env bash
set -euo pipefail

echo "--- health ---"
for attempt in $(seq 1 40); do
  if curl -fsS http://localhost:8081/health | grep -F '"status":"ok"'; then
    break
  fi
  sleep 1
done

echo "--- index writes to database ---"
curl -fsS http://localhost:8081/ | grep -F "Liczba zapisanych odwiedzin"

echo "--- database rows ---"
docker exec lesson21-db psql -U lesson21 -d lesson21 -c "SELECT COUNT(*) AS visits FROM visits;"

echo "--- docker inspect network and volumes ---"
docker inspect lesson21-web --format 'Networks={{range $name, $conf := .NetworkSettings.Networks}}{{$name}} {{end}} Mounts={{range .Mounts}}{{.Name}}:{{.Destination}} {{end}} Restart={{.HostConfig.RestartPolicy.Name}}'
docker inspect lesson21-db --format 'Networks={{range $name, $conf := .NetworkSettings.Networks}}{{$name}} {{end}} Mounts={{range .Mounts}}{{.Name}}:{{.Destination}} {{end}} Restart={{.HostConfig.RestartPolicy.Name}}'
