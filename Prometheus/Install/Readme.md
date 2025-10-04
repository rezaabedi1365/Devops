
```
/opt/monitoring/
  ├─ docker-compose.yml
  ├─ prometheus/
  │  ├─ config/prometheus.yml
  │  ├─ rules/alert.rules.yml
  │  └─ data/
  ├─ grafana/
  │  └─ data/
  ├─ alertmanager/
  │  └─ alertmanager.yml
  ├─ nginx.conf
  └─ certs/
     ├─ fullchain.pem
     └─ privkey.pem

```

docker-compose.yml
```
version: "3.9"

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - /opt/monitoring/prometheus/data:/prometheus
      - /opt/monitoring/prometheus/config/prometheus.yml:/etc/prometheus/prometheus.yml
      - /opt/monitoring/prometheus/rules:/etc/prometheus/rules
    restart: unless-stopped
    ports:
      - "9090:9090"

  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    volumes:
      - /opt/monitoring/alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
    restart: unless-stopped
    ports:
      - "9093:9093"

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    volumes:
      - /opt/monitoring/grafana/data:/var/lib/grafana
    restart: unless-stopped
    ports:
      - "3000:3000"

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    pid: host
    network_mode: host
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro

  cadvisor:
    image: google/cadvisor:latest
    container_name: cadvisor
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro

  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /opt/monitoring/certs/fullchain.pem:/etc/nginx/certs/fullchain.pem:ro
      - /opt/monitoring/certs/privkey.pem:/etc/nginx/certs/privkey.pem:ro
      - /opt/monitoring/nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - prometheus
      - grafana
    restart: unless-stopped

```

prometheus.yml
```
global:
  scrape_interval: 15s

rule_files:
  - "/etc/prometheus/rules/alert.rules.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
```

alert.rules.yml
```
groups:
  - name: example-alerts
    rules:
      - alert: HighCPUUsage
        expr: node_cpu_seconds_total{mode="system"} > 0.7
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "CPU بالاست روی {{ $labels.instance }}"
          description: "CPU بیش از 70٪ برای بیش از 2 دقیقه"
```

alertmanager.yml
```
global:
  resolve_timeout: 5m

route:
  receiver: 'telegram'

receivers:
  - name: 'telegram'
    telegram_configs:
      - bot_token: "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"
        chat_id: -1001234567890
        message: '{{ .CommonAnnotations.summary }}: {{ .CommonAnnotations.description }}'

```

