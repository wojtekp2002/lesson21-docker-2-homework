# Zadanie 2 - analiza i debugowanie aplikacji Docker

Scenariusz uruchamia Nginx z niestandardowym formatem logowania. Ruch testowy generuje odpowiedzi 200, 404 i 500. Logi sa zapisywane do named volume `lesson21_nginx_logs`, a kontener ma skonfigurowana rotacje logow Dockera.

## Uruchomienie i analiza

```bash
./scripts/run.sh
./scripts/generate-traffic.sh
./scripts/analyze.sh
```

Raport z analizy powstaje w `docs/debug-report.md`.
