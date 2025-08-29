### Sample 1 (NodPort)
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
- with replica 5
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
### Sample2 (load balance)
```

```
### Sample3 (ha proxy in external and loadbalance in trafik ingress)
```
```
