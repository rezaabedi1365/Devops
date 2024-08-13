## Pods
Create pod with kubectl
```
kubectl run test-nginx --image=nginx

kubectl create deployment nginx-web --image=nginx
kubectl expose deployment nginx-web --type NodePort --port=80
kubectl exec -it task-pv-pod -- /bin/bash
```
Create pod with yaml 
* crate pod with 2 container
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-meta          #pod name
spec:
  containers:
  - name: nginx-con         #container-name
    image: nginx:1.14.2
    ports:
    - containerPort: 80
      protocol: TCP
```
```
kubectl apply -f pod1.yml
```
delete pod
```
kubectl delete pods [podName] --force
```
verify:
```
kubectl get pods
kubectl describe pod nginx-web-01
kubectl get pods nginx-web-54f478b58f-jfsx8 -o yaml
```

