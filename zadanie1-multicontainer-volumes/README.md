# Zadanie 1 - aplikacja wielokontenerowa z woluminami

To zadanie uruchamia dwa kontenery bez Docker Compose:

- `lesson21-db` - PostgreSQL,
- `lesson21-web` - aplikacja Flask zapisujaca dane w bazie.

## Elementy wymagane w zadaniu

- named volume dla bazy: `lesson21_pgdata`,
- named volume dla statycznych plikow: `lesson21_static`,
- niestandardowa siec: `lesson21_app_net`,
- komunikacja po nazwie kontenera `lesson21-db`,
- mapowanie portu `8081:5000`,
- restart policy `unless-stopped`,
- aplikacja webowa zapisuje kazde wejscie na strone do tabeli `visits`.

## Uruchomienie

```bash
./scripts/run.sh
./scripts/test.sh
```

## Sprzatanie

```bash
./scripts/cleanup.sh
```

Domyslnie `cleanup.sh` zostawia wolumin bazy, aby pokazac trwalosc danych. Aby usunac rowniez woluminy:

```bash
REMOVE_VOLUMES=1 ./scripts/cleanup.sh
```
