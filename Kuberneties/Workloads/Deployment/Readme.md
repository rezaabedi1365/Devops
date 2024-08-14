
##  Deployment    Vs     Replication Controller (depricated)
  * +Rulling updates
  * +Rulling Backs

## Deployment
```
kubectl apply -f deploy-01.yaml
```
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable : 0
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
![image](https://github.com/user-attachments/assets/4e2c8b7a-79e6-4cf6-b319-6afb0c6f1237)
![image](https://github.com/user-attachments/assets/8f3deaca-8b76-4986-add6-4b94be920e97)

### Delete Deployment
* when you create deploment if delete pod imediatly crate agin with deployment
```
kubectl get deploy
kubectl delete deployment nginx-deployment
```

### Scaling Deployments
```
kubectl scale deployment/nginx-deployment --replicas=10
kubectl autoscale deployment/nginx-deployment --min=10 --max=15 --cpu-percent=80
kubectl get rc -o wide
```
### update image
```
kubectl set image deployment/nginx-deploy nginx=nginx:1.16.1
```
##### Updating a Deployment Using Yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  minReadySeconds: 10
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16.1
        ports:
        - containerPort: 80
```

Rolling Back to a Previous Revision
```
kubectl rollout undo deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment --to-revision=2
kubectl rollout history deployment/nginx-deployment
kubectl rollout pause deployment/nginx-deployment
```

### Checking Rollout History
```
kubectl rollout history deployment nginx-deployment
kubectl annotate deployment/nginx-deployment kubernetes.io/change-cause="image updated to 1.16.1"
kubectl rollout pause deployment/nginx-deployment![image](https://github.com/user-attachments/assets/3144258e-3fd4-4411-bfc3-fe1afc0d9f36)
```

### Interacting with Nodes and cluster
* Stopping nodes for maintenance and other managements:
```
kubectl cordon node2
kubectl uncordon node2
kubectl drain node2

```


### verify:
```
kubectl get deploy
kebectl describe deploy nginx-rs

kubectl get rs
kubectl describe rs

kubectl logs deploy/nginx-deployment
```
