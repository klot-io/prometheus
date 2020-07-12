FROM prom/prometheus-linux-armv7:v2.17.2

COPY config/prometheus.yml  /etc/prometheus/prometheus.yml