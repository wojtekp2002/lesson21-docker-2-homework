# Weryfikacja

Weryfikacja obejmuje:

1. Budowe obrazu aplikacji Flask.
2. Uruchomienie PostgreSQL i aplikacji webowej w niestandardowej sieci Docker.
3. Zapis danych do PostgreSQL przez aplikacje webowa.
4. Inspekcje sieci, woluminow i restart policy przez `docker inspect`.
5. Uruchomienie Nginx z niestandardowym formatem logow.
6. Wygenerowanie ruchu 200/404/500.
7. Analize logow i utworzenie raportu.

Pelny output znajduje sie w `docs/verification-run-output.md`.
