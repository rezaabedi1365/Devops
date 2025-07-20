## official
- https://github.com/zabbix/zabbix-docker

  ```
  git clone https://github.com/zabbix/zabbix-docker.git
  ```
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

```
services:
  server-db-init:
    extends:
      file: compose_zabbix_components.yaml
      service: server-mysql-db-init
    image: "${ZABBIX_SERVER_MYSQL_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    volumes:
      - /etc/timezone:/etc/timezone:ro
    depends_on:
      mysql-server:
        condition: service_started
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  proxy-db-init:
    extends:
      file: compose_zabbix_components.yaml
      service: proxy-mysql-db-init
    image: "${ZABBIX_PROXY_MYSQL_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    volumes:
      - /etc/timezone:/etc/timezone:ro
    depends_on:
      mysql-server:
        condition: service_started
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  zabbix-server:
    extends:
      file: compose_zabbix_components.yaml
      service: server-mysql
    image: "${ZABBIX_SERVER_MYSQL_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    volumes:
      - /etc/timezone:/etc/timezone:ro
    depends_on:
      server-db-init:
        condition: service_completed_successfully
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  zabbix-proxy-sqlite3:
    extends:
      file: compose_zabbix_components.yaml
      service: proxy-sqlite3
    image: "${ZABBIX_PROXY_SQLITE3_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    volumes:
      - /etc/timezone:/etc/timezone:ro
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  zabbix-proxy-mysql:
    extends:
      file: compose_zabbix_components.yaml
      service: proxy-mysql
    image: "${ZABBIX_PROXY_MYSQL_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    volumes:
      - /etc/timezone:/etc/timezone:ro
    depends_on:
      proxy-db-init:
        condition: service_completed_successfully
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  zabbix-web-apache-mysql:
    extends:
      file: compose_zabbix_components.yaml
      service: web-apache-mysql
    image: "${ZABBIX_WEB_APACHE_MYSQL_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    volumes:
      - /etc/timezone:/etc/timezone:ro
    depends_on:
      server-db-init:
        condition: service_completed_successfully
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  zabbix-web-nginx-mysql:
    extends:
      file: compose_zabbix_components.yaml
      service: web-nginx-mysql
    image: "${ZABBIX_WEB_NGINX_MYSQL_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    volumes:
      - /etc/timezone:/etc/timezone:ro
    depends_on:
      server-db-init:
        condition: service_completed_successfully
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  zabbix-agent:
    extends:
      file: compose_zabbix_components.yaml
      service: agent
    image: "${ZABBIX_AGENT_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    volumes:
      - /etc/timezone:/etc/timezone:ro
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  zabbix-java-gateway:
    extends:
      file: compose_zabbix_components.yaml
      service: java-gateway
    image: "${ZABBIX_JAVA_GATEWAY_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  zabbix-snmptraps:
    extends:
      file: compose_zabbix_components.yaml
      service: snmptraps
    image: "${ZABBIX_SNMPTRAPS_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  zabbix-web-service:
    extends:
      file: compose_zabbix_components.yaml
      service: web-service
    image: "${ZABBIX_WEB_SERVICE_IMAGE}:${ZABBIX_ALPINE_IMAGE_TAG}${ZABBIX_IMAGE_TAG_POSTFIX}"
    labels:
      com.zabbix.os: "${ALPINE_OS_TAG}"

  mysql-server:
    extends:
      file: compose_databases.yaml
      service: mysql-server

  db-data-mysql:
    extends:
      file: compose_databases.yaml
      service: db-data-mysql

  elasticsearch:
    extends:
      file: compose_databases.yaml
      service: elasticsearch

  selenium:
    extends:
      file: compose_additional_components.yaml
      service: selenium

  selenium-chrome:
    platform: linux/amd64
    extends:
      file: compose_additional_components.yaml
      service: selenium-chrome

  selenium-firefox:
    extends:
      file: compose_additional_components.yaml
      service: selenium-firefox

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      zabbix-server:
        condition: service_started
    networks:
      - frontend

networks:
  frontend:
    driver: bridge
    enable_ipv6: "${FRONTEND_ENABLE_IPV6}"
    ipam:
      driver: "${FRONTEND_NETWORK_DRIVER}"
      config:
        - subnet: "${FRONTEND_SUBNET}"

  backend:
    driver: bridge
    enable_ipv6: "${BACKEND_ENABLE_IPV6}"
    internal: true
    ipam:
      driver: "${BACKEND_NETWORK_DRIVER}"
      config:
        - subnet: "${BACKEND_SUBNET}"

  database:
    driver: bridge
    enable_ipv6: "${DATABASE_NETWORK_ENABLE_IPV6}"
    internal: true
    ipam:
      driver: "${DATABASE_NETWORK_DRIVER}"

  tools_frontend:
    driver: bridge
    enable_ipv6: "${ADD_TOOLS_ENABLE_IPV6}"
    ipam:
      driver: "${ADD_TOOLS_NETWORK_DRIVER}"
      config:
        - subnet: "${ADD_TOOLS_SUBNET}"

volumes:
  snmptraps:

secrets:
  MYSQL_USER:
    file: ${ENV_VARS_DIRECTORY}/.MYSQL_USER
  MYSQL_PASSWORD:
    file: ${ENV_VARS_DIRECTORY}/.MYSQL_PASSWORD
  MYSQL_ROOT_USER:
    file: ${ENV_VARS_DIRECTORY}/.MYSQL_ROOT_USER
  MYSQL_ROOT_PASSWORD:
    file: ${ENV_VARS_DIRECTORY}/.MYSQL_ROOT_PASSWORD

```

