# Wynik weryfikacji

Data: 2026-09-29T14:47:07+02:00

## Docker
Docker version 29.5.1, build 2518b52
Docker Compose version v5.1.3

## Zadanie 1 - aplikacja wielokontenerowa
ce0c77c6bebd094afb4ec66b924c1f83f486955d5ef4a1e2d4a44fe81b6168c1
cde2c26566c93f30b6a4748488073b2319745268bd795341ce45c6988d6fbda0
NAMES                  IMAGE                PORTS                                         STATUS
lesson21-web           lesson21-webapp:v1   0.0.0.0:8081->5000/tcp, [::]:8081->5000/tcp   Up Less than a second
lesson21-db            postgres:16-alpine   5432/tcp                                      Up 3 seconds
lesson21-nginx-debug   nginx:alpine         0.0.0.0:8082->80/tcp, [::]:8082->80/tcp       Up About a minute
--- health ---
{"database":"lesson21-db","status":"ok"}
--- index writes to database ---
    <p>Liczba zapisanych odwiedzin w bazie: <span class="count">8</span></p>
--- database rows ---
 visits 
--------
      8
(1 row)

--- docker inspect network and volumes ---
Networks=lesson21_app_net  Mounts=lesson21_static:/app/static-volume  Restart=unless-stopped
Networks=lesson21_app_net  Mounts=lesson21_pgdata:/var/lib/postgresql/data  Restart=unless-stopped

## Trwalosc danych w woluminie bazy
7ca32a825b33640f56fbdb564227a27b972fe61590c6dd415de771ba4e51949a
a383acad016ea265695a92cab736d3f8d8cdd218f4a0eeb9b470f266548fe5cf
NAMES                  IMAGE                PORTS                                         STATUS
lesson21-web           lesson21-webapp:v1   0.0.0.0:8081->5000/tcp, [::]:8081->5000/tcp   Up Less than a second
lesson21-db            postgres:16-alpine   5432/tcp                                      Up 3 seconds
lesson21-nginx-debug   nginx:alpine         0.0.0.0:8082->80/tcp, [::]:8082->80/tcp       Up About a minute
30b7b735d5aed0f32720bce95b32bb1e3feb4a1f0aa044eca0e73a6480886a79
78616d1908323ee68d1870c5b324a4be07f625904f6fddace17eed3e4f05b67b
NAMES                  IMAGE                PORTS                                         STATUS
lesson21-web           lesson21-webapp:v1   0.0.0.0:8081->5000/tcp, [::]:8081->5000/tcp   Up Less than a second
lesson21-db            postgres:16-alpine   5432/tcp                                      Up 3 seconds
lesson21-nginx-debug   nginx:alpine         0.0.0.0:8082->80/tcp, [::]:8082->80/tcp       Up About a minute
Rows before restart: 9
Rows after restart with same volume: 9

## Zadanie 2 - Nginx debug
4e5bbeac28f9390191a0dc2593f798e8f961ff9b0c96a181b7d87b2863d8a2ff
NAMES                  PORTS                                     STATUS
lesson21-nginx-debug   0.0.0.0:8082->80/tcp, [::]:8082->80/tcp   Up Less than a second
404
404
500
500
500
# Raport analizy kontenera Nginx

## Polecenia

- docker run z customowym plikiem konfiguracyjnym Nginx
- docker logs lesson21-nginx-debug
- docker inspect lesson21-nginx-debug

## Status kontenera
NAMES                  STATUS                  PORTS
lesson21-nginx-debug   Up Less than a second   0.0.0.0:8082->80/tcp, [::]:8082->80/tcp

## Konfiguracja restartu i log rotation
Restart=on-failure MaximumRetryCount=3 LogDriver=json-file LogOptions={"max-file":"3","max-size":"1m"}

## Sieci i mounty
Networks=bridge  Mounts=bind:->/usr/share/nginx/html volume:lesson21_nginx_logs->/host-logs bind:->/etc/nginx/conf.d/default.conf 

## Liczba odpowiedzi wedlug kodu HTTP
      6 200
      2 404
      3 500

## Ostatnie logi Nginx
2026/09/29 12:47:34 [notice] 1#1: using the "epoll" event method
2026/09/29 12:47:34 [notice] 1#1: nginx/1.31.3
2026/09/29 12:47:34 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/09/29 12:47:34 [notice] 1#1: OS: Linux 7.0.0-28-generic
2026/09/29 12:47:34 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1024:524288
2026/09/29 12:47:34 [notice] 1#1: start worker processes
2026/09/29 12:47:34 [notice] 1#1: start worker process 21
2026/09/29 12:47:34 [notice] 1#1: start worker process 22
2026/09/29 12:47:34 [notice] 1#1: start worker process 23
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET / HTTP/1.1" 200 226 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET / HTTP/1.1" 200 226 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET / HTTP/1.1" 200 226 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET / HTTP/1.1" 200 226 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET / HTTP/1.1" 200 226 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET / HTTP/1.1" 200 226 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET /missing-page HTTP/1.1" 404 153 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET /another-missing HTTP/1.1" 404 153 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET /error500 HTTP/1.1" 500 177 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET /error500 HTTP/1.1" 500 177 "-" "curl/8.18.0" request_time=0.000 upstream_time=-
172.17.0.1 - - [29/Sep/2026:12:47:34 +0000] "GET /error500 HTTP/1.1" 500 177 "-" "curl/8.18.0" request_time=0.000 upstream_time=-

## Alert o bledach
ALERT: detected 5 HTTP error responses in Nginx logs

## Wnioski

- Kontener poprawnie serwuje strone glowna.
- Odpowiedzi 404 i 500 sa widoczne w docker logs i mozna je policzyc automatycznie.
- Kontener ma named volume na logi/artefakty host-side oraz rotacje logow json-file.
- Rotacja logow json-file ogranicza ryzyko niekontrolowanego wzrostu plikow logow Dockera.

## Propozycje optymalizacji

- Dodac metryki Prometheus/Nginx exporter dla kodow 4xx/5xx.
- W srodowisku produkcyjnym wysylac logi do centralnego systemu, np. Loki lub ELK.
- Dodac healthcheck HTTP i limity zasobow CPU/RAM.

## Docker volumes
VOLUME NAME                                                        DRIVER
lesson21_nginx_logs                                                local
lesson21_pgdata                                                    local
lesson21_static                                                    local
