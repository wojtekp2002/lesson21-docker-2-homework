#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."
report="docs/debug-report.md"

{
  echo "# Raport analizy kontenera Nginx"
  echo
  echo "## Polecenia"
  echo
  echo "- docker run z customowym plikiem konfiguracyjnym Nginx"
  echo "- docker logs lesson21-nginx-debug"
  echo "- docker inspect lesson21-nginx-debug"
  echo "- docker exec lesson21-nginx-debug sh -c 'cat /var/log/nginx/access.log'"
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
  docker exec lesson21-nginx-debug sh -c "awk '{print \\$9}' /var/log/nginx/access.log | sort | uniq -c"
  echo
  echo "## Ostatnie logi Nginx"
  docker exec lesson21-nginx-debug sh -c "tail -n 20 /var/log/nginx/access.log"
  echo
  echo "## Alert o bledach"
  ./zadanie2-nginx-debug/scripts/error-alert.sh || true
  echo
  echo "## Wnioski"
  echo
  echo "- Kontener poprawnie serwuje strone glowna."
  echo "- Odpowiedzi 404 i 500 sa widoczne w logach i mozna je policzyc automatycznie."
  echo "- Logi aplikacji sa przechowywane w named volume, wiec mozna je analizowac niezaleznie od cyklu zycia kontenera."
  echo "- Rotacja logow json-file ogranicza ryzyko niekontrolowanego wzrostu plikow logow Dockera."
  echo
  echo "## Propozycje optymalizacji"
  echo
  echo "- Dodac metryki Prometheus/Nginx exporter dla kodow 4xx/5xx."
  echo "- W srodowisku produkcyjnym wysylac logi do centralnego systemu, np. Loki lub ELK."
  echo "- Dodac healthcheck HTTP i limity zasobow CPU/RAM."
} | tee "$report"
