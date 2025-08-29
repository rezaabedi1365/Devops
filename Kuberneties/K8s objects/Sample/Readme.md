### Sample 1 (port forward)
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
### Sample2 (load balance)
```

```
