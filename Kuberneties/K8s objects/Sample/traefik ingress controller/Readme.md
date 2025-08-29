
👌 خیلی خوب، حالا می‌خوای یک **وب اپلیکیشن (Nginx)** و یک **دیتابیس (MySQL)** داشته باشی که:

1. **وب** از طریق **LoadBalancer / NodePort + Traefik Ingress Controller** در دسترس باشه.
2. **Traefik** به عنوان **Reverse Proxy لایه ۴** کار کنه و ترافیک رو بین Podهای وب توزیع کنه.
3. دیتابیس هم فقط داخل کلاستر استفاده بشه (نیازی به اکسپوز مستقیم نداره).

---

### 📄 فایل YAML (Nginx + MySQL + Traefik IngressRoute TCP)

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: webdb-NS
---
# Secret برای MySQL
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: webdb-NS
type: Opaque
data:
  MYSQL_ROOT_PASSWORD: cm9vdDEyMw==   # root123
---
# Deployment برای Nginx
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: webdb-NS
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
---
# Service برای Nginx (ClusterIP - برای Traefik)
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: webdb-NS
spec:
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
---
# Deployment برای MySQL
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deploy
  namespace: webdb-NS
spec:
  replicas: 1
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        env:
          - name: MYSQL_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-secret
                key: MYSQL_ROOT_PASSWORD
        ports:
        - containerPort: 3306
---
# Service داخلی برای MySQL
apiVersion: v1
kind: Service
metadata:
  name: mysql-svc
  namespace: webdb-NS
spec:
  selector:
    app: db
  ports:
    - port: 3306
      targetPort: 3306
---
# IngressRoute TCP برای Nginx در Traefik (Reverse Proxy L4)
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRouteTCP
metadata:
  name: nginx-ingress-tcp
  namespace: webdb-NS
spec:
  entryPoints:
    - web  # Traefik entrypoint باید در Config تعریف شده باشه (port 80)
  routes:
    - match: HostSNI(`*`)
      services:
        - name: nginx-svc
          port: 80
```

---

### 📌 توضیح

* **Nginx**

  * Deployment با ۳ Replica.
  * Service از نوع `ClusterIP` → Traefik روی اون Load Balance می‌کنه.
  * دسترسی بیرونی از طریق **Traefik IngressRouteTCP** روی entrypoint پیش‌فرض (`web` → پورت 80).

* **MySQL**

  * Deployment با ۱ Replica.
  * فقط از طریق Service داخلی `mysql-svc` روی پورت 3306 در دسترسه (داخل کلاستر).
  * از بیرون اکسپوز نشده (امن‌تر).

* **Traefik**

  * به صورت **Reverse Proxy Layer 4** کار می‌کنه چون ما `IngressRouteTCP` تعریف کردیم.
  * تمام درخواست‌های TCP روی entrypoint `web` به `nginx-svc:80` فوروارد می‌شن.
  * Load Balancing بین Replicaهای Nginx انجام میشه.

---

### 🚀 تست

بعد از نصب Traefik به عنوان Ingress Controller:

```bash
kubectl apply -f webdb.yaml
```

سپس با آدرس نود و پورت ورودی Traefik (مثلاً 80) به وب سرور دسترسی داری:

```
http://<NodeIP>:80
```

---

👉 می‌خوای من همینو ارتقا بدم و **TLS (HTTPS) با Let’s Encrypt در Traefik** هم برات فعال کنم؟
