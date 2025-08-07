# Kubernetes YAML Generator 
- https://gimlet.io/k8s-yaml-generator
- https://k8syaml.com/


##  get commands
```
kubectl cluster-info
```
```
kubectl get nodes
kubectl get nodes -o wide
kubectl get nodes -o yaml
```
```
kubectl get pods -A
kubectl get pods -n <NamaSpace>
```
```
kubectl get svc
```
```
kubectl get deployment,pod,svc
```

## logs
```
kubectl logs nginx-pod-01 -f
kubectl logs rc/nginx-rc

```
- Kubectl Resource Requests & Limits
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

