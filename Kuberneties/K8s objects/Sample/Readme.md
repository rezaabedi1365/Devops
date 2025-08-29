### Sample 1 (port forward)
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


### Sample2 (load balance)
```

```
### Sample3 (ha proxy in external and loadbalance in trafik ingress)
```
```
