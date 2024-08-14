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

### Rolling Back to a Previous Revision
daemonset
* daemonset/nginx-Daemonset
* daemonset.app/nginx-Daemonset
```
kubectl rollout undo daemonset/nginx-Daemonset
kubectl rollout undo daemonset/nginx-Daemonset --to-revision=2

kubectl annotate daemonset/nginx-deployment kubernetes.io/change-cause="image updated to 1.16.1"

kubectl rollout history daemonset/nginx-Daemonset
kubectl rollout status daemonset/nginx-Daemonset

kubectl rollout pause daemonset/nginx-Daemonset
kubectl rollout resume daemonset/nginx-Daemonset


```


### verify:
```
kubectl get daemonset
kebectl describe daemonset nginx-rs

kubectl get rs
kubectl describe rs

kubectl logs daemonset/nginx-Daemonset
```
