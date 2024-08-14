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
      role: front
  template:
    metadata:
      labels:
        app: nginx
        env: prod
        role: front
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
          - containerPort: 80
            protocol: TCP
```
verify:
```
kubectl get pods
kubectl describe rs Replica-1
```
