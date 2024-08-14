* Replicaset
* Deployment
* DaemonSet
* StatefulSet
* Job
* CronJob

## ReplicaSet
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: Replica-1        
spec:
  Replicas: 3
  selector:
    matchLabels:
      app: nginx
      env: prod
  template:
    <pod template>
```
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: Replica-1        
spec:
  Replicas: 3
  selector:
    matchLabels:
      app: nginx
      env: prod
  template:
    metadata:
      labels:
        app: nginx
        env: prod
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```
verify:
```
kubectl get pods
kubectl describe rs Replica-1
```
