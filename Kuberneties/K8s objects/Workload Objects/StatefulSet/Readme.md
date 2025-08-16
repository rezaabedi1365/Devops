🔹 updateStrategy

    Two possible strategies for StatefulSets:

      1- RollingUpdate (default)

    Pods are updated sequentially, respecting their ordinal index.

    Extra option:

    partition:

  partition: 0 → update all pods.

    partition: n → only pods with ordinal ≥ n are updated; lower ones stay on the old version.

OnDelete

Pods will not update automatically when the StatefulSet spec changes.

You need to manually delete each pod → the new version will be created.

✅ Key difference vs. DaemonSet:

DaemonSet uses maxUnavailable for rolling updates.

StatefulSet uses partition, because pod order and identity matter.

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
