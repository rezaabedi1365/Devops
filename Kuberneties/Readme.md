
## Pods
```
kubectl create deployment nginx-web --image=nginx
kubectl expose deployment nginx-web --type NodePort --port=80
```

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: default
spec:
  containers:
  - name: nginx-ctr
    image: nginx:latest
    ports:
    - containerPort:80
```
verify:
```
kubectl apply -f pod1.yml
kubectl get pods
kubectl describe pod nginx-web-01
kubectl get pods nginx-web-54f478b58f-jfsx8 -o yaml
```
## Replication Controller
```
apiVersion: v1
kind: ReplicationController
metadate:
  name=nginx-rc
  namespace: default
spec:
  replicas: 5
  selector:
    app: nginx

  template:
    metadate:
      labels:
        app:  nginx
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort:80
```
verify:
```
kubectl apply -f rc.yaml
kunectl get rc -o wide
```

##  Nodes
```
kubectl get nodes
kubectl get nodes -o wide
kubectl get nodes -o yaml

kubectl cluster-info
kubectl get pods -n kube-system
kubectl get deployment,pod,svc
```
