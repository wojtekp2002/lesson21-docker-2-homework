# Lekcja 21 - Docker: woluminy, sieci, inspekcja i logi

Repozytorium zawiera rozwiazanie zadan domowych z lekcji 21. Praca byla wykonana na maszynie `main-learnit`, na ktorej jest zainstalowany Docker.

## Zadania

1. Aplikacja wielokontenerowa uruchamiana recznie bez Docker Compose:
   - kontener PostgreSQL,
   - kontener aplikacji webowej Flask,
   - named volume dla danych bazy,
   - named volume dla statycznych plikow aplikacji,
   - niestandardowa siec bridge,
   - mapowanie portu na hosta,
   - restart policy.

2. Analiza i debugowanie aplikacji Docker:
   - Nginx z prostymi stronami HTML,
   - niestandardowy format logowania,
   - wygenerowany ruch 200/404/500,
   - analiza logow i `docker inspect`,
   - volume na logi,
   - rotacja logow kontenera,
   - prosty skrypt alertujacy o bledach.

## Szybka weryfikacja

```bash
./zadanie1-multicontainer-volumes/scripts/run.sh
./zadanie1-multicontainer-volumes/scripts/test.sh
./zadanie1-multicontainer-volumes/scripts/cleanup.sh

./zadanie2-nginx-debug/scripts/run.sh
./zadanie2-nginx-debug/scripts/generate-traffic.sh
./zadanie2-nginx-debug/scripts/analyze.sh
./zadanie2-nginx-debug/scripts/cleanup.sh
```

Szczegolny zapis pelnej weryfikacji jest w `docs/verification-run-output.md`.
