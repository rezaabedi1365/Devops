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
