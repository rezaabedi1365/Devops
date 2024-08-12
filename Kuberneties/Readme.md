# Kubernetes YAML Generator 
- https://gimlet.io/k8s-yaml-generator
- https://k8syaml.com/

## Pods
Create pod with kubectl
```
kubectl create deployment nginx-web --image=nginx
kubectl expose deployment nginx-web --type NodePort --port=80
```
Create pod with yaml 
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

##  Deployment    Vs     Replication Controller (depricated)
  + Rulling updates
  + Rulling Backs

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
Scaling Deployments
```
kubectl scale deployment/nginx-deployment --replicas=10
kubectl autoscale deployment/nginx-deployment --min=10 --max=15 --cpu-percent=80
kubectl get rc -o wide
```
update image
```
kubectl set image deployment/nginx-deploy nginx=nginx:1.16.1
```
Updating a Deployment Using Yaml
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

Checking Rollout History
```
kubectl rollout history deployment/nginx-deployment
kubectl annotate deployment/nginx-deployment kubernetes.io/change-cause="image updated to 1.16.1"
kubectl rollout pause deployment/nginx-deployment![image](https://github.com/user-attachments/assets/3144258e-3fd4-4411-bfc3-fe1afc0d9f36)
```

Interacting with Nodes and cluster ![image](https://github.com/user-attachments/assets/e34817b5-5e65-40b5-afa8-4f66cf816392)
* Stopping nodes for maintenance and other managements:
```
kubectl cordon node2
kubectl uncordon node2
kubectl drain node2

```


verify:
```
kubectl get deploy
kebectl describe deploy nginx-rs

kubectl get rs
kubectl describe rs

kubectl logs deploy/nginx-deployment
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
## Namespace
```
kubectl create ns test
kubectl get nodes
```
## Service
* ClusterIP
* NodePort
    - above 30000
* LoadBalancer
    - ingress
    - Metallb on bermetal
       + ALB
       + NLB
       + GWLB 
* ExternalName
    - Cname Record
 
#### cluster ip (local)
10.10.12.10:8080  > 10.10.12.20:80

#### Nodeport service
nodeport 5.120.11.20:30001 > service port (master port) 10.244.2.8:8080  > pod port(target port) 10.10.12.20:80 or [Pod /pods/rc]

```
apiVersion: v1
kind: Service
metadate:
  name: nginx-svc
  labels:
    app: myapp
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376 
```
ClusterIP Service
```
apiVersion: v1
kind: Endpoints
metadate:
  name: nginx-svc
subsets:
  - addresses:
      - ip: 192.0.2.42
    ports:
      - protocol: TCP
        port: 80
        targetPort: 9376
```
NodePort Service
```
apiVersion: v1
kind: Service
metadate:
  name: nginx-svc
spec:
  type: NodePort
  ports:
    - targetPort: 80    #(pod port)
      port: 8080        #(service port)
      nodetPort: 30008  #(host port)
  selector:
    app: myapp #(pod label)
```


verify:
```
kubectl get svc
kubectl describe svc nginx-svc-01

kubectl get ep -o wide
kubectl describe ep svc-01
```
```
kubectl create -f svc.yaml
```


## logs
```
kubectl logs nginx-pod-01 -f
kubectl logs rc/nginx-rc

```
