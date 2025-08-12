# Kubernetes (K8S)

## Verify
```
kubectl cluster-info
```
```
kubectl get nodes
kubectl get nodes -o wide  #show with detail
kubectl get nodes -o yaml  #show in yaml format
```
```
kubectl get pods -A
kubectl get pods -n <NamaSpace>
```
```
kubectl get ns
kubectl get namespace
```
```
kubectl get svc
```
```
kubectl get deployment -A
kubectl get deployment -n <NamaSpace>
```

## logs
```
kubectl logs <PodName>
kubectl logs nginx-pod-01 -f
kubectl logs rc/nginx-rc
```
-----------------------------------------------------------------------
# Create Pod 
- Helm
- yaml file

### YAML Generator 
  * https://gimlet.io/k8s-yaml-generator
  * https://k8syaml.com/

- pod  
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx-ctr
    image: nginx:latest
    ports:
    - conteinerPort: 80
```
```
kubectl create -f pod.yml
kubectl apply -f pod,yml
```
# limit Resource

- Resource Requests & Limits
```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: demo
spec:
  hard:
    requests.cpu: 500m
    requests.memory: 100Mib
    limits.cpu: 700m
    limits.memory: 500Mib
```
```
kubectl create -f pod.yml
kubectl apply -f pod,yml
```
- Default Limit Range in a Namespace
```
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
spec:
  limits:
  - default:
      memory: 512Mi
    defaultRequest:
      memory: 256Mi
    type: Container
```
```
kubectl create -f pod.yml
kubectl apply -f pod.yml
```

