- use for create pod in all nod and always available with high priority
- suitable for agent same as zabbix and ....
- can use nod selector
## DaemonSets
* revisionHistoryLimit
* updateStrategy
    - rollingUpdate
    - maxUnavailable
    - onDelete
------------------------------------------------------------------------------
### Simple
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nginx-daemonset
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
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
```
### nodeSelector 
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nginx-daemonset
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      nodeSelector:
        role: worker   # فقط روی نودهایی با این label اجرا میشه
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```

### nodeAffinity
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nginx-daemonset
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            preference:
              matchExpressions:
              - key: role
                operator: In
                values:
                - worker
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80

```

### revisionHistoryLimit
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

- Rolling Back to a Previous Revision

```
kubectl rollout history daemonset/nginx-Daemonset
kubectl rollout status daemonset/nginx-Daemonset
```
```
kubectl rollout undo daemonset/nginx-Daemonset
kubectl rollout undo daemonset/nginx-Daemonset --to-revision=2
```
```
kubectl annotate daemonset/nginx-deployment kubernetes.io/change-cause="image updated to 1.16.1"
```

```
kubectl rollout pause daemonset/nginx-Daemonset
kubectl rollout resume daemonset/nginx-Daemonset
```




### verify:
```
kubectl get daemonset
kubectl describe daemonset nginx-daemonset

kubectl get rs
kubectl describe rs

kubectl logs daemonset/nginx-Daemonset
```
