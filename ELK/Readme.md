# Elastic Stack
### 1- elasticsearch
Store, index, and search logs/metrics

### 2- kibana
Visualize, explore, and analyze logs/metrics from Elasticsearch.

### 3- Logstash
 Collect, optimize, then forward logs/metrics to Elasticsearch;
 suitable for large-scale environment
 you can direktly forward logs/metric to elasticsearch
    
### 4- Beats
  - filebeat (Install agent)
     + Application,Nginx,Apache logs (Retrurn code 40x,30x,20x)
  - metricbeat (Install agent)
     + System and Service Metrics (CPU/RAM/Disk)
  - Winlogbeat (Install anget)
     + Event Viewer (Application, Security, System, DNS, etc.)
  - Auditbeat (Install agent)
     + Security evidense
  - Packetbeat (Install agent & SPAN port)
     + Network Trafik and Protocol Analyzer
  - Heartbeat (Install on ELK or Monitoring server for send Heartbeat)
     + Service and API Uptime


  

| Beat                                                    | کاربرد اصلی                                      | موارد استفاده                                                                         |
| ------------------------------------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------- |
| **Filebeat**                                            | جمع‌آوری لاگ‌ها از فایل‌ها                       | لاگ‌های وب‌سرور (Nginx, Apache), اپلیکیشن‌ها، syslog، container logs                  |
| **Metricbeat**                                          | جمع‌آوری متریک‌ها                                | CPU, RAM, Disk, Network + متریک سرویس‌ها (MySQL, Nginx, Redis, Docker, Kubernetes)    |
| **Winlogbeat**                                          | جمع‌آوری لاگ‌های ویندوز (Event Viewer)           | Application, System, Security logs                                                    |
| **Packetbeat**                                          | آنالیز ترافیک شبکه                               | HTTP, DNS, MySQL, PostgreSQL، بررسی latency و error در لایه شبکه                      |
| **Auditbeat**                                           | مانیتورینگ امنیتی و تغییر فایل‌ها                | File Integrity Monitoring، فعالیت کاربران، پردازش‌ها (مناسب برای Security/Compliance) |
| **Heartbeat**                                           | مانیتورینگ uptime و latency سرویس‌ها             | چک کردن دسترس‌پذیری APIها، وب‌سایت‌ها، TCP/ICMP/Ping، شبیه UptimeRobot                |
| **Functionbeat** (منسوخ شده و جایگزین با Elastic Agent) | جمع‌آوری لاگ/رویداد از Cloud Functions           | AWS Lambda, Google Cloud Functions (برای cloud-native environments)                   |
| **Elastic Agent** (جدید و جایگزین بیشتر Beatsها)        | یک Agent همه‌کاره برای Logs + Metrics + Security | ساده‌تر از Beats جداگانه، مخصوصاً برای Elastic Cloud و Fleet Management               |



### docker-compose.yml
```
#version: '3.8'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.15.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=true
      - ELASTIC_PASSWORD=elastic
      - ES_JAVA_OPTS=-Xms2g -Xmx2g
    ulimits:
      memlock:
        soft: -1
        hard: -1
    ports:
      - "9200:9200"
    volumes:
      - es_data:/usr/share/elasticsearch/data

  kibana:
    image: docker.elastic.co/kibana/kibana:8.15.0
    container_name: kibana
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=elastic
      - ELASTICSEARCH_PASSWORD=elastic
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch

  logstash:
    image: docker.elastic.co/logstash/logstash:8.15.0
    container_name: logstash
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    ports:
      - "5044:5044"
    depends_on:
      - elasticsearch

  filebeat:
    image: docker.elastic.co/beats/filebeat:8.15.0
    container_name: filebeat
    user: root
    volumes:
      - ./filebeat.yml:/usr/share/filebeat/filebeat.yml
      - /var/log:/var/log:ro
    depends_on:
      - logstash

volumes:
  es_data:
    driver: local

```
### logstash.conf
- user => "elastic"
- password => "elastic"
```
input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    user => "elastic"
    password => "elastic"
    index => "my-logs-%{+YYYY.MM.dd}"
  }
}


```
### filebeat.yml
- you can forward to elasticsearch without preprocess
```
#with repelace in filebeat.yml
output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
```

```
filebeat.inputs:
  # لاگ‌های Nginx
  - type: log
    enabled: true
    paths:
      - /var/log/nginx/access.log
      - /var/log/nginx/error.log
    tags: ["nginx"]

  # لاگ‌های Apache
  - type: log
    enabled: true
    paths:
      - /var/log/apache2/access.log
      - /var/log/apache2/error.log
    tags: ["apache"]

  # لاگ‌های اپلیکیشن (اختیاری)
  - type: log
    enabled: true
    paths:
      - /var/log/myapp/*.log
    tags: ["app"]


output.logstash:
  hosts: ["logstash:5044"]

setup.kibana:
  host: "http://kibana:5601"

```

### metricbeat.yml
- you can forward to elasticsearch without preprocess
```
#with repelace in metricbeat.yml
output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
```
```
metricbeat.modules:
  # سیستم عامل
  - module: system
    metricsets:
      - cpu
      - memory
      - network
      - diskio
      - filesystem
    period: 10s
    hosts: ["localhost"]

  # سرویس‌های وب
  - module: nginx
    metricsets:
      - stubstatus
    period: 10s
    hosts: ["http://nginx:80"]
    enabled: true

  - module: apache
    metricsets:
      - status
    period: 10s
    hosts: ["http://apache:80/server-status"]
    enabled: true

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]

setup.kibana:
  host: "http://kibana:5601"
```


### winlogbeat.yml
- you can forward to elasticsearch without preprocess
```
#with repelace in winlogbeat.yml
output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
```

```
winlogbeat.event_logs:
  - name: Application
  - name: System
  - name: Security
    ignore_older: 72h  # فقط 3 روز اخیر

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]

setup.kibana:
  host: "http://kibana:5601"

```
### packetbeat.yml
- you can forward to elasticsearch without preprocess
```
#with repelace in packetbeat.yml
output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
```

```
packetbeat.interfaces.device: any  # شنود روی همه‌ی اینترفیس‌ها

packetbeat.protocols:
  - type: http
    ports: [80, 8080, 9200]
  - type: dns
    ports: [53]
  - type: mysql
    ports: [3306]

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]

setup.kibana:
  host: "http://kibana:5601"
```


### heartbeat.yml
- you can forward to elasticsearch without preprocess
```
#with repelace in heartbeat.yml
output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
```

```
heartbeat.monitors:
  - type: http
    id: api-healthcheck
    name: My API Health
    schedule: "@every 30s"
    urls: ["http://myapi.local/health"]

  - type: tcp
    id: tcp-service
    name: TCP Check
    schedule: "@every 30s"
    hosts: ["db.local:3306"]

  - type: icmp
    id: ping-server
    name: Ping Test
    schedule: "@every 30s"
    hosts: ["8.8.8.8"]

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]

setup.kibana:
  host: "http://kibana:5601"
```
### auditbeat.yml
- you can forward to elasticsearch without preprocess
```
#with repelace in auditbeat.yml
output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
```

```
  - module: auditd
    resolve_ids: true
    failure_mode: log
    backlog_limit: 8196

  - module: file_integrity
    paths:
      - /bin
      - /usr/bin
      - /etc
      - /var/log

  - module: system
    datasets:
      - host    # اطلاعات میزبان
      - login   # ورود/خروج کاربران
      - package # تغییر پکیج‌ها
      - process # پردازش‌ها
      - socket  # ارتباطات شبکه‌ای

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]

setup.kibana:
  host: "http://kibana:5601"
```
