use for create pod in all nod and always available with high priority
- can use nod selector
## DaemonSets
* revisionHistoryLimit
* updateStrategy
    - rollingUpdate
    - maxUnavailable
    - onDelete
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nginx-Daemonset
spec:
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      app: nginx
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
