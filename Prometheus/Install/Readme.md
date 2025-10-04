
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
version: '3.7'

volumes:
    prometheus_data: {}
    grafana_data: {}

networks:
  front-tier:
  back-tier:

services:

  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus/:/etc/prometheus/
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
    ports:
      - 9090:9090
    links:
      - cadvisor:cadvisor
      - alertmanager:alertmanager
#      - pushgateway:pushgateway
    depends_on:
      - cadvisor
#      - pushgateway
    networks:
      - back-tier
    restart: always
#    deploy:
#      placement:
#        constraints:
#          - node.hostname == ${HOSTNAME}

  node-exporter:
    image: quay.io/prometheus/node-exporter:latest
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
      - /:/host:ro,rslave
    command: 
      - '--path.rootfs=/host'
      - '--path.procfs=/host/proc' 
      - '--path.sysfs=/host/sys'
      - --collector.filesystem.ignored-mount-points
      - "^/(sys|proc|dev|host|etc|rootfs/var/lib/docker/containers|rootfs/var/lib/docker/overlay2|rootfs/run/docker/netns|rootfs/var/lib/docker/aufs)($$|/)"
    ports:
      - 9100:9100
    networks:
      - back-tier
    restart: always
    deploy:
      mode: global

  alertmanager:
    image: prom/alertmanager
    ports:
      - 9093:9093
    volumes:
      - ./alertmanager/:/etc/alertmanager/
    networks:
      - back-tier
    restart: always
    command:
      - '--config.file=/etc/alertmanager/config.yml'
      - '--storage.path=/alertmanager'
#    deploy:
#      placement:
#        constraints:
#          - node.hostname == ${HOSTNAME}
  cadvisor:
    image: ghcr.io/google/cadvisor:159a7b2-159a7b24b50446f9ae319a32f0812bdf9dac1bb3
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    ports:
      - 8080:8080
    networks:
      - back-tier
    restart: always
    privileged: true
    deploy:
      mode: global

  grafana:
    image: grafana/grafana
    user: "472"
    depends_on:
      - prometheus
    ports:
      - 3000:3000
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning/:/etc/grafana/provisioning/
    env_file:
      - ./grafana/config.monitoring
    networks:
      - back-tier
      - front-tier
    restart: always

#  pushgateway:
#    image: prom/pushgateway
#    restart: always
#    expose:
#      - 9091
#    ports:
#      - "9091:9091"
#    networks:
#      - back-tier

```

prometheus.yml
```
# /opt/monitoring/prometheus/config/prometheus.yml

global:
  scrape_interval: 15s        # زمان پیش‌فرض برای جمع‌آوری داده‌ها
  evaluation_interval: 15s    # زمان پیش‌فرض برای ارزیابی قوانین
  external_labels:
    monitor: 'my-project'

# بارگذاری فایل‌های قوانین
rule_files:
  - 'alert.rules.yml'

# تنظیمات Alertmanager
alerting:
  alertmanagers:
    - scheme: http
      static_configs:
        - targets:
            - "alertmanager:9093"

# تنظیمات Scrape
scrape_configs:

  - job_name: 'prometheus'
    scrape_interval: 15s
    static_configs:
      - targets: ['prometheus:9090']   # تغییر localhost به نام سرویس Docker

  - job_name: 'cadvisor'
    scrape_interval: 15s
    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'node-exporter'
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


nginx.conf
```
# /opt/monitoring/nginx.conf

# ریدایرکت تمام ترافیک HTTP به HTTPS
server {
    listen 80;
    server_name _;

    location / {
        return 301 https://$host$request_uri;
    }
}

# سرور HTTPS
server {
    listen 443 ssl;
    server_name _;

    ssl_certificate /etc/nginx/certs/fullchain.pem;
    ssl_certificate_key /etc/nginx/certs/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Prometheus در مسیر /prometheus
    location /prometheus/ {
        proxy_pass http://prometheus:9090/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Grafana در مسیر /grafana
    location /grafana/ {
        proxy_pass http://grafana:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # در صورت نیاز به سایر مسیرها، می‌توانید location های جدید اضافه کنید
    location / {
        return 404;
    }
}
```
