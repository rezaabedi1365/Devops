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
<img width="688" height="904" alt="image" src="https://github.com/user-attachments/assets/036ddf7d-dd12-4b40-96b4-2f6cb5df018e" />




 ------------------------------------------------------------------------------------------------------------------------------

### 1- cluster ip (local)
- By Default create ClusterIP Network service for your pods you dont need to create on . 
[ClusterIP]10.103.81.165:8080  > (Pod-IP)10.244.3.10:80
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
clusterIP: 10.105.10.10          # optional and use for spcify IP
```
```
kubectl get svc
```
### 2- Nodeport service
:heavy_check_mark:  Nodeport service with HA proxy use for project
- [ExternalIP:3000] 5.120.11.20:30008 > [ClusterIP] 10.244.2.8:8080  > [Pod-IP] 10.10.12.20:80

- Create Namespace > Pod > Nodport Service
```
apiVersion: v1
kind: Namespace
metadata:
  name: zabbix-NS

---

apiVersion: v1
kind: Pod
metadata:                  
  name: nginx-pod           #PodName     
  namespace: zabbix-NS
  labels:
    app: zabbix
spec:
  containers:
  - name: nginx-cont        #ContainerName
    image: nginx:1.14.2
    ports:
    - containerPort: 80
      protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: zabbix-NS      #in service must write pod namespace 
spec:
  type: NodePort
  ports:
    - port: 8080         #(service port)
      targetPort: 80     #(container port in pod )
      nodePort: 30008   #(host port)
  selector:
    app: zabbix           #Point to pod label>app
```
- Create Namespace > Deployment insted Pod > Nodport Service
```
apiVersion: v1
kind: Namespace
metadata:
  name: zabbix-NS
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: zabbix-NS
  labels:
    app: zabbix
spec:
  replicas: 1
  selector:
    matchLabels:
      app: zabbix
  template:
    metadata:
      labels:
        app: zabbix
    spec:
      containers:
      - name: nginx-cont
        image: nginx:1.14.2
        ports:
        - containerPort: 80
          protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: zabbix-NS
spec:
  type: NodePort
  selector:
    app: zabbix
  ports:
    - port: 8080        # پورت سرویس
      targetPort: 80    # پورت داخل پاد
      nodePort: 30008   # پورت روی نود

```
show pods behind specfic service
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
<img width="1170" height="460" alt="image" src="https://github.com/user-attachments/assets/1d505ddf-5d6a-4be6-b35a-e5c6a4e4f00c" />

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
