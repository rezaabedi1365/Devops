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
        app: nginx
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort:80
```
Scaling Replication Controller
```
kubectl scale --replicas=8 rc/nginx-rc

```
exec 
```
kubectl exec -it nginx-rc --bash
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
*   - ingress
    - Metallb on bermetal
       + ALB
       + NLB
       + GWLB 
* ExternalName
    - Cname Record
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
```
```
kubectl create -f svc.yaml
```


## logs
```
kubectl logs nginx-pod-01 -f
kubectl logs rc/nginx-rc

```
