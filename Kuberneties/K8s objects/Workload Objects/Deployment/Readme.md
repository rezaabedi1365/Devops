
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
  name: deploy-nginx-1-14-2
  namespace: push-stage
  labels:
    app: nginx
    version: "1.14.2"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
        version: "1.14.2"
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

```
```
kubectl apply -f deploy_nginx-1.14.2.yaml
```
```
kubectl get pods -n push-stage
kubectl get pods -n push-stage -o wide
kubectl get deployment -n push-stage
kubectl get deployment -n push-stage -o wide
kubectl get rs -n push-stage
```
### Scaling Deployments
- HorizontalPodAutoscaler (HPA)
```
kubectl scale deployment/deploy-nginx-1-14-2 --replicas=10 -n push-stage
```
```
kubectl autoscale deployment/deploy-nginx-1-14-2 \
  --min=10 \
  --max=15 \
  --cpu-percent=80 \
  -n push-stage
```
## anotate
```
kubectl annotate deployment/deploy-nginx-1-14-2 \
  kubernetes.io/change-cause="image updated to 1.16.1" \
  -n push-stage --overwrite
```
```
kubectl rollout history deployment -n push-stage
```
# Rollout
- Rollout with yaml
- Rollout with kubectl

## roolout with kubectl

```
kubectl set image deployment/deploy-nginx-1-14-2 \
  nginx=nginx:1.16.1 \
  -n push-stage
```
- anotate
```
kubectl annotate deployment/deploy-nginx-1-14-2 \
  kubernetes.io/change-cause="image updated to 1.16.1" \
  -n push-stage --overwrite
```
- rollout history
```
kubectl rollout history deployment -n push-stage
```

## roulout with yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-nginx-1-14-2
  namespace: push-stage
  labels:
    app: nginx
    version: "1.16.1"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app: nginx
        version: "1.16.1"
    spec:
      containers:
      - name: nginx
        image: nginx:1.16.1
        ports:
        - containerPort: 80

```
```
kubectl apply -f deploy-01.yaml
```
```
kubectl rollout history deployment/nginx-deployment
kubectl rollout status deployment/nginx-deployment
```

## RollBack to a Previous Revision

```
kubectl rollout history deployment/nginx-deployment
kubectl rollout status deployment/nginx-deployment
```

```
kubectl rollout undo deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment --to-revision=2
```

```
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
