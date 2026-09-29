#!/usr/bin/env bash
set -euo pipefail

for _ in $(seq 1 5); do
  curl -fsS http://localhost:8082/ >/dev/null
done

for path in missing-page another-missing; do
  curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:8082/$path" || true
done

for _ in $(seq 1 3); do
  curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8082/error500 || true
done
