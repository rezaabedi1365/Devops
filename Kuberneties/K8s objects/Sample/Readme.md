### Sample 1 (port forward)
```
apiVersion: v1
kind: Namespace
metadata:
  name: push-NS

---

apiVersion: v1
kind: Pod
metadata:                  
  name: nginx-pod           #PodName     
  namespace: push-NS
  labels:
    app: push-web
spec:
  containers:
  - name: nginx-cont        #ContainerName
    image: nginx:1.14.2
    ports:
    - containerPort: 80
      protocol: TCP
    - containerPort: 443
      protocol: TCP
---
apiVersion: v1
kind: Pod
metadata:                  
  name: mysql-pod           #PodName     
  namespace: push-NS
  labels:
    app: push-db
spec:
  containers:
  - name: mysql-cont        #ContainerName
    image: mysql:latest
    ports:
    - containerPort: 3306
      protocol: TCP
---

apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: push-NS      #in service must write pod namespace 
spec:
  type: NodePort
  ports:
    - port: 8080         #(service port)
      targetPort: 80     #(container port in pod )
      nodePort: 30008   #(host port)
  selector:
    app: push-web           #Point to pod label>app
```


### Sample2 (load balance)
```

```
### Sample3 (ha proxy in external and loadbalance in trafik ingress)
```
```
