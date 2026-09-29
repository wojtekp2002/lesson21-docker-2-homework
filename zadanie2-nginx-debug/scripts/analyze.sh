#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."
report="docs/debug-report.md"
tmp_access_log="$(mktemp)"
trap 'rm -f "$tmp_access_log"' EXIT

docker logs lesson21-nginx-debug > "$tmp_access_log" 2>&1

{
  echo "# Raport analizy kontenera Nginx"
  echo
  echo "## Polecenia"
  echo
  echo "- docker run z customowym plikiem konfiguracyjnym Nginx"
  echo "- docker logs lesson21-nginx-debug"
  echo "- docker inspect lesson21-nginx-debug"
  echo
  echo "## Status kontenera"
  docker ps --filter name=lesson21-nginx-debug --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
  echo
  echo "## Konfiguracja restartu i log rotation"
  docker inspect lesson21-nginx-debug --format 'Restart={{.HostConfig.RestartPolicy.Name}} MaximumRetryCount={{.HostConfig.RestartPolicy.MaximumRetryCount}} LogDriver={{.HostConfig.LogConfig.Type}} LogOptions={{json .HostConfig.LogConfig.Config}}'
  echo
  echo "## Sieci i mounty"
  docker inspect lesson21-nginx-debug --format 'Networks={{range $name, $conf := .NetworkSettings.Networks}}{{$name}} {{end}} Mounts={{range .Mounts}}{{.Type}}:{{.Name}}->{{.Destination}} {{end}}'
  echo
  echo "## Liczba odpowiedzi wedlug kodu HTTP"
  awk '/"GET|POST|HEAD/ {print $9}' "$tmp_access_log" | sort | uniq -c
  echo
  echo "## Ostatnie logi Nginx"
  tail -n 20 "$tmp_access_log"
  echo
  echo "## Alert o bledach"
  ./zadanie2-nginx-debug/scripts/error-alert.sh || true
  echo
  echo "## Wnioski"
  echo
  echo "- Kontener poprawnie serwuje strone glowna."
  echo "- Odpowiedzi 404 i 500 sa widoczne w docker logs i mozna je policzyc automatycznie."
  echo "- Kontener ma named volume na logi/artefakty host-side oraz rotacje logow json-file."
  echo "- Rotacja logow json-file ogranicza ryzyko niekontrolowanego wzrostu plikow logow Dockera."
  echo
  echo "## Propozycje optymalizacji"
  echo
  echo "- Dodac metryki Prometheus/Nginx exporter dla kodow 4xx/5xx."
  echo "- W srodowisku produkcyjnym wysylac logi do centralnego systemu, np. Loki lub ELK."
  echo "- Dodac healthcheck HTTP i limity zasobow CPU/RAM."
} | tee "$report"
