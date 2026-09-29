#!/usr/bin/env bash
set -euo pipefail

errors=$(docker exec lesson21-nginx-debug awk '{print $9}' /var/log/nginx/access.log | grep -E '^(4|5)' | wc -l)

if [ "$errors" -gt 0 ]; then
  echo "ALERT: detected $errors HTTP error responses in Nginx logs"
  exit 1
fi

echo "OK: no HTTP errors detected"
