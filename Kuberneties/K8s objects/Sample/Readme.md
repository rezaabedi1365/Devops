# Sample 1 (NodPort)
```
apiVersion: v1
kind: Namespace
metadata:
  name: push-NS
---
# Secret برای پسورد دیتابیس
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: push-NS
type: Opaque
data:
  # مقدار "root123" به صورت base64 انکد شده
  MYSQL_ROOT_PASSWORD: cm9vdDEyMw==
---
# Pod برای Nginx
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: push-NS
  labels:
    app: push-web
spec:
  containers:
  - name: nginx-cont
    image: nginx:1.14.2
    ports:
    - containerPort: 80
      protocol: TCP
    - containerPort: 443
      protocol: TCP
---
# Pod برای MySQL
apiVersion: v1
kind: Pod
metadata:
  name: mysql-pod
  namespace: push-NS
  labels:
    app: push-db
spec:
  containers:
  - name: mysql-cont
    image: mysql:8.0
    env:
      - name: MYSQL_ROOT_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mysql-secret
            key: MYSQL_ROOT_PASSWORD
    ports:
    - containerPort: 3306
      protocol: TCP
---
# Service برای Nginx (نوع NodePort)
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: push-NS
spec:
  type: NodePort
  ports:
    - port: 8080
      targetPort: 80
      nodePort: 30008
  selector:
    app: push-web
---
# Service داخلی برای MySQL
apiVersion: v1
kind: Service
metadata:
  name: mysql-svc
  namespace: push-NS
spec:
  type: ClusterIP
  ports:
    - port: 3306
      targetPort: 3306
  selector:
    app: push-db

```
### with replica 5
```
apiVersion: v1
kind: Namespace
metadata:
  name: push-NS
---
# Secret برای پسورد دیتابیس
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: push-NS
type: Opaque
data:
  # مقدار "root123" به صورت base64 انکد شده
  MYSQL_ROOT_PASSWORD: cm9vdDEyMw==
---
# Deployment برای Nginx
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: push-NS
spec:
  replicas: 5
  selector:
    matchLabels:
      app: push-web
  template:
    metadata:
      labels:
        app: push-web
    spec:
      containers:
      - name: nginx-cont
        image: nginx:1.14.2
        ports:
        - containerPort: 80
        - containerPort: 443
---
# Deployment برای MySQL
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deploy
  namespace: push-NS
spec:
  replicas: 5
  selector:
    matchLabels:
      app: push-db
  template:
    metadata:
      labels:
        app: push-db
    spec:
      containers:
      - name: mysql-cont
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
# Service برای Nginx (نوع NodePort)
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: push-NS
spec:
  type: NodePort
  ports:
    - port: 8080
      targetPort: 80
      nodePort: 30008
  selector:
    app: push-web
---
# Service داخلی برای MySQL
apiVersion: v1
kind: Service
metadata:
  name: mysql-svc
  namespace: push-NS
spec:
  type: ClusterIP
  ports:
    - port: 3306
      targetPort: 3306
  selector:
    app: push-db

```
📌 توضیح تغییرات

برای هر سرویس (Nginx و MySQL) یک Deployment تعریف شده.

تعداد Replica برای هر Deployment → ۵ تا.

سرویس‌ها (nginx-svc و mysql-svc) ترافیک رو بین این ۵ Replica پخش می‌کنن (Load Balancing).

سرویس MySQL از نوع ClusterIP هست → فقط داخل کلاستر در دسترسه.

سرویس Nginx از نوع NodePort هست → از بیرون هم با پورت 30008 در دسترس قرار می‌گیره.

⚠️ نکته مهم: داشتن ۵ Replica برای MySQL به صورت Pod ساده باعث میشه هر کدوم یک دیتابیس جداگانه داشته باشن (Sync نمی‌شن).
برای MySQL واقعی باید از StatefulSet + PersistentVolume استفاده کنی تا دیتای پایدار و هماهنگ داشته باشی.

👉 می‌خوای من همین فایل رو برات تبدیل کنم به Nginx با Deployment و MySQL با StatefulSet + PVC تا دیتابیس‌هات واقعی و پایدار باشن؟

#### (MySQL Master + Automatic Replica Replication) + Nginx
```
apiVersion: v1
kind: Namespace
metadata:
  name: push-NS
---
# Secret برای پسوردها
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: push-NS
type: Opaque
data:
  MYSQL_ROOT_PASSWORD: cm9vdDEyMw==     # root123
  MYSQL_REPL_PASSWORD: cmVwbDEyMw==     # repl123
---
# ConfigMap برای Master و Replica
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
  namespace: push-NS
data:
  master.cnf: |
    [mysqld]
    log-bin=mysql-bin
    server-id=1
    binlog-do-db=testdb
  replica.cnf: |
    [mysqld]
    server-id=2
    relay-log=relay-log
---
# Deployment برای Nginx
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: push-NS
spec:
  replicas: 5
  selector:
    matchLabels:
      app: push-web
  template:
    metadata:
      labels:
        app: push-web
    spec:
      containers:
      - name: nginx-cont
        image: nginx:1.14.2
        ports:
        - containerPort: 80
        - containerPort: 443
---
# Service برای Nginx
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: push-NS
spec:
  type: NodePort
  ports:
    - port: 8080
      targetPort: 80
      nodePort: 30008
  selector:
    app: push-web
---
# Headless Service برای MySQL
apiVersion: v1
kind: Service
metadata:
  name: mysql-hs
  namespace: push-NS
spec:
  clusterIP: None
  ports:
    - port: 3306
  selector:
    app: push-db
---
# StatefulSet برای MySQL
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  namespace: push-NS
spec:
  serviceName: mysql-hs
  replicas: 3   # 1 master + 2 replicas
  selector:
    matchLabels:
      app: push-db
  template:
    metadata:
      labels:
        app: push-db
    spec:
      initContainers:
      - name: init-mysql
        image: mysql:8.0
        command:
          - "sh"
          - "-c"
          - |
            set -e
            if [[ "$(hostname)" == "mysql-0" ]]; then
              echo "Initializing Master..."
              mysql -h localhost -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY '$MYSQL_REPL_PASSWORD'; GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%'; FLUSH PRIVILEGES;"
            else
              echo "Configuring Replica..."
              mysql -h localhost -uroot -p$MYSQL_ROOT_PASSWORD -e "CHANGE MASTER TO MASTER_HOST='mysql-0.mysql-hs.push-NS.svc.cluster.local', MASTER_USER='repl', MASTER_PASSWORD='$MYSQL_REPL_PASSWORD', MASTER_AUTO_POSITION=1; START SLAVE;"
            fi
        env:
          - name: MYSQL_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-secret
                key: MYSQL_ROOT_PASSWORD
          - name: MYSQL_REPL_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-secret
                key: MYSQL_REPL_PASSWORD
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
        env:
          - name: MYSQL_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-secret
                key: MYSQL_ROOT_PASSWORD
        volumeMounts:
          - name: mysql-pv
            mountPath: /var/lib/mysql
          - name: config
            mountPath: /etc/mysql/conf.d
      volumes:
        - name: config
          configMap:
            name: mysql-config
            items:
              - key: master.cnf
                path: master.cnf
              - key: replica.cnf
                path: replica.cnf
  volumeClaimTemplates:
  - metadata:
      name: mysql-pv
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
---
# Service برای دسترسی به Master
apiVersion: v1
kind: Service
metadata:
  name: mysql-master
  namespace: push-NS
spec:
  type: ClusterIP
  selector:
    statefulset.kubernetes.io/pod-name: mysql-0
  ports:
    - port: 3306
---
# Service برای دسترسی به Replicaها
apiVersion: v1
kind: Service
metadata:
  name: mysql-replicas
  namespace: push-NS
spec:
  type: ClusterIP
  selector:
    app: push-db
  ports:
    - port: 3306

```
📌 توضیح:

mysql-0 به عنوان Master کانفیگ می‌شه و کاربر repl براش ساخته می‌شه.

mysql-1, mysql-2 به صورت Replica به Master وصل می‌شن (با دستور CHANGE MASTER TO... START SLAVE;).

mysql-master → فقط به Master وصل می‌شه.

mysql-replicas → به همه Replicaها وصل می‌شه (برای queryهای Read-only).

همه چیز بدون دخالت دستی راه می‌افته 🚀

# Sample2 (load balance)
```

```
# Sample3 (ha proxy in external and loadbalance in trafik ingress)
```
```
