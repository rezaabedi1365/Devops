
## Service
* ClusterIP
* NodePort
    - above 30000
* LoadBalancer
    - ingress
    - Metallb on bermetal
       + ALB
       + NLB
       + GWLB 
* ExternalName
    - Cname Record
![image](https://github.com/user-attachments/assets/4b233b0f-4672-4a33-9c7c-88107050a1ee)

 ------------------------------------------------------------------------------------------------------------------------------

#### cluster ip (local)
10.10.12.10:8080  > 10.10.12.20:80
```
apiVersion: v1
kind: Endpoints
metadate:
  name: nginx-svc  
subsets:
  - addresses:
      - ip: 192.0.2.42
    ports:
      - protocol: TCP
        port: 80
        targetPort: 9376
```
#### Nodeport service
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


verify:
```
kubectl get svc
kubectl describe svc nginx-svc-01

kubectl get ep -o wide
kubectl describe ep svc-01
```
```
kubectl create -f svc.yaml
```


