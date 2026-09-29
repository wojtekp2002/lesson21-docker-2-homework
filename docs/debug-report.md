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
