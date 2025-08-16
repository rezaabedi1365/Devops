وضیح‌ها:

revisionHistoryLimit
مثل Deployment و DaemonSet → تعداد history (ControllerRevisions) که نگه داشته میشه.

updateStrategy

حالت‌های قابل استفاده:

RollingUpdate (پیش‌فرض): پادها به صورت تدریجی آپدیت میشن.

پارامتر partition خیلی مهمه:

اگر partition=0 → همه پادها آپدیت میشن.

اگر partition=n → فقط پادهایی با ایندکس ≥ n آپدیت میشن، بقیه همون ورژن قدیمی می‌مونن.

OnDelete: مثل DaemonSet → پادها فقط وقتی آپدیت میشن که خودت دستی پاکشون کنی.

🔎 فرق اصلی با DaemonSet:

DaemonSet از maxUnavailable استفاده می‌کنه، ولی StatefulSet از partition.

StatefulSet روی ترتیب و identity پادها خیلی حساسه.
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
