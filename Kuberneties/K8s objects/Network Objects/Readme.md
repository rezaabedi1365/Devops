

- Service
- Network Policy
-----------------------------------------------
# kubernetirs Network
- ingress (Kubernetes Resource)
     * Network Service
- Ha proxy ( external Load Balancer / Reverse Proxy )
     * Network Service
  
### Network Service
* ClusterIP (Default)
* NodePort
    - above 30000
* LoadBalancer (depricated)
    - Metallb on bermetal
       + ALB
       + NLB
       + GWLB 
* ExternalName
    - Cname Record
<img width="3000" height="3900" alt="image" src="https://github.com/user-attachments/assets/8a0bcb70-0d49-4a79-8173-f098d38532e1" />


 ------------------------------------------------------------------------------------------------------------------------------

### 1- cluster ip (local)
(Service)10.103.81.165:8080  > (Pod)10.244.3.10:80
```
apiVersion: v1
kind: Service
metadate:
  name: nginx-svc
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
clusterIP: 10.105.10.10          # optional and use for spcefy IP
```
```
kubectl get svc
```
### 2- Nodeport service
nodeport 5.120.11.20:30001 > service port (master port) 10.244.2.8:8080  > pod port(target port) 10.10.12.20:80 or [Pod /pods/rc]
```
apiVersion: v1
kind: Service
metadate:
  name: nginx-svc
spec:
  type: NodePort
  ports:
    - port: 8080         #(service port)
      targetPort: 80     #(container port in pod )
      nodetPort: 30008   #(host port)
  selector:
    app: myapp           #Point to podName
```
show pods behind specfic service
kubectl describe svc nginx-svc
```
kubectl describe svc nginx-svc
```
verify:
```
kubectl get svc
kubectl describe svc nginx-svc

kubectl get ep -o wide
kubectl describe ep svc-01
```
```
kubectl create -f svc.yaml
```
### 3- LoadBalancer Service
Use olny in Service Provider - Cant use in local Kuberneties
```
apiVersion: v1
kind: Service
metadate:
  name: nginx-svc
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

### 4- ExternalName Service
Use for Cname in external name in internal environment
```
apiVersion: v1
kind: Service
metadate:
  name: nginx-svc
spec:
  type: ExternalName
  externalName: examlple.ir

```
