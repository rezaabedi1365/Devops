# install with Helm
```
helm search repo zabbix-community
```
```
helm repo add zabbix-community https://zabbix-community.github.io/helm-zabbix/
helm repo update
```

```
helm install zabbix zabbix-community/zabbix --namespace monitoring --create-namespace
kubectl get pods -n monitoring
```
# Port Forward
- Temporarly
  * kubectl port-forward
  * Kftray (Graphicy)
- Permanently
  * Ingress Controller (HAProxy, NGINX)
  * Kubernetes Service (NodePort, LoadBalancer)
  * iptables
  * NGINX Reverse Proxy (میتواند جزو Ingress یا جداگانه باشد)

 
```
kubectl get ingress -A
kubectl get svc -n monitoring
kubectl get svc -A -o wide
```
### kubectl port-forward
 
- method1
```
kubectl port-forward svc/zabbix-zabbix-web -n monitoring 8080:80
```
- method2 : run in background
```
nohup kubectl port-forward svc/zabbix-zabbix-web -n monitoring 8080:80 > port-forward.log 2>&1 &
```
### Ingress Controller (HAProxy, NGINX)
- for user Ingress Controller (HAProxy, NGINX) you must install it
##### Install Ingress Controller (HAProxy)
<img width="758" height="270" alt="image" src="https://github.com/user-attachments/assets/15ec9e5d-7eaf-4ec8-b65e-da6ce2de6720" />

```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add haproxy-ingress https://haproxy-ingress.github.io/charts
helm repo update

helm install haproxy-ingress haproxy-ingress/haproxy-ingress \
--create-namespace --namespace ingress-controller

```
- Ingress Controller (HAProxy) with Loadbalancer
```
helm install haproxy-ingress haproxy-ingress/haproxy-ingress \
--create-namespace --namespace ingress-controller \
--set controller.service.type=LoadBalancer
```
- Ingress Controller (HAProxy) with Nodeport
```
helm install haproxy-ingress haproxy-ingress/haproxy-ingress \
--create-namespace --namespace ingress-controller \
--set controller.service.type=NodePort \
--set controller.service.nodePorts.http=30080 \
--set controller.service.nodePorts.https=30443
```
- if you want use 80 , 443
```
helm upgrade --install haproxy-ingress haproxytech/kubernetes-ingress --namespace ingress \
--set controller.service.nodePorts.http=80 \
--set controller.service.nodePorts.https=443
```

verfy:
```
kubectl get svc --all-namespaces | grep haproxy
kubectl get pods --all-namespaces | grep haproxy
```


<img width="1044" height="49" alt="image" src="https://github.com/user-attachments/assets/a5bcc535-1cbb-4e00-982d-d798c112f421" />

<img width="1039" height="48" alt="image" src="https://github.com/user-attachments/assets/0f1267f5-cd6e-4284-b0d0-13c524da81ca" />




```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: zabbix-ingress
  namespace: your-zabbix-namespace
  annotations:
    kubernetes.io/ingress.class: "haproxy"
spec:
  rules:
  - host: zabbix.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: zabbix-service
            port:
              number: 80


```
```
kubectl apply -f zabbix-ingress.yaml
```
```
kubectl get ingress -A
kubectl get ingress -n your-zabbix-namespace
kubectl describe ingress <ingress-name> -n <namespace>
kubectl delete ingress zabbix-web-ingress -n your-zabbix-namespace
```
- With TLS
```
kubectl create secret tls zabbix-tls-secret --cert=path/to/tls.crt --key=path/to/tls.key -n monitoring
```
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: zabbix-web-ingress
  namespace: monitoring
 
spec:
  ingressClassName: haproxy   
  tls:
  - hosts:
    - zabbix.faradis.net
    secretName: zabbix-tls-secret
  rules:
  - host: zabbix.faradis.net
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: zabbix-zabbix-web
            port:
              number: 80

```
```
kubectl apply -f zabbix-ingress-TLS.yaml
```
```
kubectl get ingress -A
kubectl get ingress -n your-zabbix-namespace
kubectl describe ingress <ingress-name> -n <namespace>
kubectl delete ingress zabbix-web-ingress -n your-zabbix-namespace
```
<img width="758" height="47" alt="image" src="https://github.com/user-attachments/assets/11b79b8d-cdc7-4fde-bba8-662519343e18" />

### Kubernetes Service (NodePort)
```
apiVersion: v1
kind: Service
metadata:
  name: zabbix-service
  namespace: your-zabbix-namespace
spec:
  type: NodePort
  selector:
    app: zabbix
  ports:
  - protocol: TCP
    port: 80          # پورت داخلی سرویس
    targetPort: 80    # پورت داخل پاد Zabbix
    nodePort: 30080   # پورت باز روی نودهای کلاستر برای دسترسی خارجی

```
```
kubectl apply -f zabbix-ingress.yaml
```
```
kubectl get services --all-namespaces
kubectl delete service <service-name> -n <namespace>
```
<img width="924" height="140" alt="image" src="https://github.com/user-attachments/assets/fdde6600-4966-4939-b3af-0f5fd1bc9c35" />

### Kubernetes Service (loadbalancer)
```
apiVersion: v1
kind: Service
metadata:
  name: zabbix-loadbalancer
  namespace: your-zabbix-namespace
spec:
  type: LoadBalancer
  selector:
    app: zabbix
  ports:
  - protocol: TCP
    port: 80          # پورت سرویس داخلی
    targetPort: 80    # پورت داخل پاد Zabbix

```

```
kubectl get services --all-namespaces
kubectl delete service <service-name> -n <namespace>
```
<img width="932" height="154" alt="image" src="https://github.com/user-attachments/assets/e9999634-5d62-48dc-8650-4a4d3e92e1c6" />


# verify:
```
kubectl get namespaces
```
```
kubectl get pods -n monitoring
```



# Tshoot
```
#kubectl describe node <node-name>
kubectl describe pod zabbix-zabbix-web-6f4b768545-j9h28 -n monitoring
```

```
kubectl logs zabbix-postgresql-0 -n monitoring
```

```
kubectl exec -n monitoring -it zabbix-zabbix-web-6f4b768545-j9h28 -- nslookup google.com
```
# auto Scale
```
kubectl autoscale deployment zabbix-zabbix-web -n monitoring --min=2 --max=10 --cpu-percent=50

```
