### install with Helm
```
helm repo add haproxy-ingress https://haproxy-ingress.github.io/charts
helm repo update
```

- install
```
helm install haproxy-ingress haproxy-ingress/haproxy-ingress --create-namespace --namespace ingress-controller
```
```
helm install haproxy-ingress haproxy-ingress/haproxy-ingress \
  --create-namespace --namespace ingress-controller \
  --set controller.service.type=LoadBalancer
```

```
helm install haproxy-ingress haproxy-ingress/haproxy-ingress \
  --create-namespace --namespace ingress-controller \
  --set controller.service.type=NodePort \
  --set controller.service.nodePorts.http=30080 \
  --set controller.service.nodePorts.https=30443

```

verify:
```
kubectl get pods -n ingress-controller
kubectl get svc -n ingress-controller
```

### Port forward with haproxy
- nano zabbix-ingress.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: zabbix-web-ingress
  namespace: monitoring
spec:
  ingressClassName: haproxy
  rules:
  - host: zabbix.yourdomain.com
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
kubectl apply -f zabbix-ingress.yaml
```
```
kubectl delete -f zabbix-ingress.yaml
kubectl delete ingress zabbix-web-ingress -n monitoring
```
verify:
```
kubectl get ingress --all-namespaces
kubectl get ingress -n monitoring
kubectl describe ingress <ingress-name> -n monitoring
kubectl get ingress <ingress-name> -n monitoring -o yaml
```
### Port Forward with TLS
- create secret with PEM
```
kubectl create secret tls zabbix-tls-secret -n monitoring --cert=/path/to/tls.crt.pem --key=/path/to/tls.key.pem
```
```
spec:
  ingressClassName: haproxy
  tls:
  - hosts:
    - zabbix.yourdomain.com
    secretName: zabbix-tls-secret
  rules:
  - host: zabbix.yourdomain.com
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
