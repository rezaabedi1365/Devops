
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
# my global config
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.
  evaluation_interval: 15s # By default, scrape targets every 15 seconds.
  # scrape_timeout is set to the global default (10s).

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'my-project'

# Load and evaluate rules in this file every 'evaluation_interval' seconds.
rule_files:
  - 'alert.rules'
  # - "first.rules"
  # - "second.rules"

# alert
alerting:
  alertmanagers:
  - scheme: http
    static_configs:
    - targets:
      - "alertmanager:9093"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.

  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 15s

    static_configs:
         - targets: ['localhost:9090']

  - job_name: 'cadvisor'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 15s

    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'node-exporter'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 15s
  
    static_configs:
      - targets: ['node-exporter:9100']
```

alert.rules.yml
```
groups:
- name: example
  rules:

  # Alert for any instance that is unreachable for >2 minutes.
  - alert: service_down
    expr: up == 0
    for: 2m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} down"
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 2 minutes."

  - alert: high_load
    expr: node_load1 > 0.5
    for: 2m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} under high load"
      description: "{{ $labels.instance }} of job {{ $labels.job }} is under high load."
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

