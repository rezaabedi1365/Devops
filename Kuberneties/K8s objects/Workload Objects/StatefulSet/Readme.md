<img width="816" height="479" alt="image" src="https://github.com/user-attachments/assets/adfabc55-086c-46e1-b862-6b7c43bd06da" />


```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nginx-sts
spec:
  serviceName: "nginx"
  replicas: 3
  revisionHistoryLimit: 5   # تعداد history که نگه داشته میشه
  selector:
    matchLabels:
      app: nginx
  updateStrategy:
    type: RollingUpdate      # پیش‌فرضه
    rollingUpdate:
      partition: 0           # از چه ایندکسی به بعد آپدیت بشه
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi

```
