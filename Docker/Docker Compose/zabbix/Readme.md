## official
- https://github.com/zabbix/zabbix-docker

  ```
  docker compose -f docker-compose_v3_alpine_mysql_latest.yaml up -d
  ```

## non-official
- https://github.com/heyvaldemar/zabbix-docker-compose

## Manual
در **ریپازیتوری رسمی Zabbix Docker**
[https://github.com/zabbix/zabbix-docker](https://github.com/zabbix/zabbix-docker)
کامپوز‌های پیش‌فرضی که در فولدر `docker-compose/` هست
✅ شامل Zabbix Server، Proxy، Agent، Web (Frontend)، Database، Java Gateway
❌ اما **Grafana** به صورت پیش‌فرض در این پکیج‌ها نیست.

---

### 🔹 چرا گرافانا نیست؟

گرافانا یک ابزار جدا برای مانیتورینگ است و به صورت رسمی در پکیج Zabbix ارائه نمی‌شود.
اما می‌توانی **Grafana + Zabbix Plugin** را جداگانه بالا بیاوری و به Zabbix Server وصل کنی.

---

### 🔹 اگر می‌خواهی Grafana همراه Zabbix با Docker Compose داشته باشی:

باید خودت به docker-compose.yml زیر اضافه کنی مثل:

```yaml
grafana:
  image: grafana/grafana:latest
  container_name: grafana
  ports:
    - "3000:3000"
  environment:
    - GF_SECURITY_ADMIN_USER=admin
    - GF_SECURITY_ADMIN_PASSWORD=admin
  depends_on:
    - zabbix-server
  networks:
    - frontend
```

و بعد
📥 داخل گرافانا پلاگین **Zabbix Datasource** را نصب کنی.
(از Marketplace خود Grafana)

---


