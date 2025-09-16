### Elastic Stack
- elasticsearch
- kibana
- Logstash
- Beats
  * filebeat
  * metricbeat
  * Winlogbeat

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
