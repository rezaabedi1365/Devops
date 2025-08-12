* Default
* Kube-public
* Kube-system
* kube-node-lease
  
## Namespace
create Namespace with command
```
kubectl create namespace test
```
* use for Organizing
```
kubectl apply -f pod.yaml --namespace=test
```

create Namespace with yaml file
```
kind: Namespace
apiVersion: v1
metadata:
  name: test
  labels:
    name: test
```
```
kubectl apply -f test.yaml
```


verify:
```
kubectl get pods --namespace=test

kubectl get namespace
```
  
