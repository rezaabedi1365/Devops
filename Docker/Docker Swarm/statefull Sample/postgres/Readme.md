عالی 👌
بریم با یه مثال **واقعی و تست‌شده از PostgreSQL با replication در Docker Swarm** که هم ساده باشه، هم مفهومی رو شفاف برسونه.

---

## 🎯 هدف

ما می‌خوایم توی Swarm سه سرویس بالا بیاریم:

* `postgres-master` → دیتابیس اصلی (write/read)
* `postgres-replica` → یک replica فقط برای خواندن
* `pgadmin` → برای مدیریت و بررسی اتصال‌ها

و replication بین master و replica به‌صورت **streaming replication** در سطح PostgreSQL تنظیم می‌شه.

---

## 🧩 فایل: `docker-compose.yml`

```yaml
version: "3.9"

services:
  postgres-master:
    image: bitnami/postgresql:16
    environment:
      - POSTGRESQL_REPLICATION_MODE=master
      - POSTGRESQL_REPLICATION_USER=repl_user
      - POSTGRESQL_REPLICATION_PASSWORD=repl_pass
      - POSTGRESQL_USERNAME=admin
      - POSTGRESQL_PASSWORD=admin123
      - POSTGRESQL_DATABASE=mydb
    volumes:
      - master_data:/bitnami/postgresql
    networks:
      - pg_net
    deploy:
      replicas: 1
      placement:
        constraints: [node.role == manager]

  postgres-replica:
    image: bitnami/postgresql:16
    depends_on:
      - postgres-master
    environment:
      - POSTGRESQL_REPLICATION_MODE=slave
      - POSTGRESQL_REPLICATION_USER=repl_user
      - POSTGRESQL_REPLICATION_PASSWORD=repl_pass
      - POSTGRESQL_MASTER_HOST=postgres-master
      - POSTGRESQL_PASSWORD=admin123
    volumes:
      - replica_data:/bitnami/postgresql
    networks:
      - pg_net
    deploy:
      replicas: 1
      placement:
        constraints: [node.role == worker]

  pgadmin:
    image: dpage/pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@local
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "8080:80"
    networks:
      - pg_net
    depends_on:
      - postgres-master

networks:
  pg_net:
    driver: overlay

volumes:
  master_data:
  replica_data:
```

---

## ⚙️ نحوه‌ی استقرار در Swarm

اول مطمئن شو که Swarm فعال شده:

```bash
docker swarm init
```

بعد فایل رو deploy کن:

```bash
docker stack deploy -c docker-compose.yml pgcluster
```

با این دستور سه سرویس ایجاد می‌شن:

```bash
docker service ls
```

---

## 🔍 بررسی وضعیت

1. برای دیدن containerها:

   ```bash
   docker ps
   ```

2. برای ورود به master:

   ```bash
   docker exec -it $(docker ps -q -f name=pgcluster_postgres-master) psql -U admin -d mydb
   ```

3. برای بررسی replication روی master:

   ```sql
   SELECT * FROM pg_stat_replication;
   ```

   باید ببینی که replica بهش وصل شده و حالت `streaming` داره ✅

---

## 🌐 دسترسی به PgAdmin

بعد از بالا اومدن سرویس‌ها، از مرورگر برو به:

```
http://localhost:8080
```

با یوزر و پسورد:

```
admin@local / admin
```

و به عنوان سرور جدید این رو اضافه کن:

* Host: `postgres-master`
* Port: `5432`
* Username: `admin`
* Password: `admin123`

---

## 🧠 نکات مهم

1. در Swarm، هر نود کانتینر خودش رو داره، پس اگه از volumeهای local استفاده می‌کنی، داده فقط روی همون نود ذخیره می‌شه.
   برای داده پایدارتر بهتره از **NFS، GlusterFS یا volume driverهای توزیع‌شده** استفاده کنی.

2. این مثال فقط یک replica داره ولی می‌تونی replicaهای بیشتری با تغییر `replicas: N` برای سرویس `postgres-replica` اضافه کنی — هر replica خودش به master وصل می‌شه و داده‌ها رو sync می‌کنه.

---

می‌خوای نسخه‌ی **High-Availability (با failover خودکار با Patroni + etcd)** رو هم برات بنویسم؟
اون سطح enterprise هست ولی خیلی جالبه برای محیط‌های production.
