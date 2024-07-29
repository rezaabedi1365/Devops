
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
kubectl apply -f pod1.yml


```
kubectl get pods
kubectl describe pod nginx-web-01

kubectl get nodes
kubectl get nodes -o wide

kubectl cluster-info
kubectl get pods -n kube-system
kubectl get deployment,pod,svc
```
