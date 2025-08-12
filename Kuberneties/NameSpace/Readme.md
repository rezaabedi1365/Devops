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
verify:
```
kubectl get pods --namespace=test

kubectl get namespace
```
<img width="725" height="498" alt="image" src="https://github.com/user-attachments/assets/4e038fae-a12b-4511-a0af-4c4cc44017d8" />
  


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
