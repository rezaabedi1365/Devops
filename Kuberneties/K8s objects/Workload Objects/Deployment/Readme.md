
##  Deployment    &     ReplicaSet 
:x: Replication Controller (depricated)
  * +Rulling updates
  * +Rulling Backs
------------------------------------------------ 
In deployment we create replicaset
## Deployment
* revisionHistoryLimit
* strategy
  - recreate
  - rollingUpdate
     + maxSure
     + maxUnavailable
--------------------------------------------------
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
      app: nginx       ## point to PodName
  template:            ## pod information template for create replicas
    metadata:
      labels:
        app: nginx     ## PodName
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
```
kubectl apply -f deploy-01.yaml
```
```
kubectl get deployment
kubectl get deployment -o wide
kubectl get deployment <DeploymentName>
```
### Scaling Deployments
```
kubectl scale deployment/nginx-deployment --replicas=10
kubectl autoscale deployment/nginx-deployment --min=10 --max=15 --cpu-percent=80
kubectl get rc -o wide
```
## anotate
```
kubectl annotate deployment/nginx-deployment kubernetes.io/change-cause="image updated to 1.16.1"
```

# Rolleout
```
kubectl set image deployment/nginx-deploy nginx=nginx:1.16.1
```
##### roulout with yaml
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

##### Rollout with yaml
```
kubectl set image 
```

```
kubectl rollout history deployment/nginx-deployment
kubectl rollout status deployment/nginx-deployment
```

### RollBack to a Previous Revision

```
kubectl rollout undo deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment --to-revision=2
```


kubectl rollout history deployment/nginx-deployment
kubectl rollout status deployment/nginx-deployment

kubectl rollout pause deployment/nginx-deployment
kubectl rollout resume deployment/nginx-deployment


```


### verify:
```
kubectl get deploy
kebectl describe deploy nginx-rs

kubectl get rs
kubectl describe rs

kubectl logs deploy/nginx-deployment
```

### Delete Deployment
* when you create deploment if delete pod imediatly crate agin with deployment
```
kubectl get deploy
kubectl delete deployment nginx-deployment
```
