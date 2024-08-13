# Kubernetes YAML Generator 
- https://gimlet.io/k8s-yaml-generator
- https://k8syaml.com/


##  Nodes
```
kubectl get nodes
kubectl get nodes -o wide
kubectl get nodes -o yaml

kubectl cluster-info
kubectl get pods -n kube-system
kubectl get deployment,pod,svc
```

## logs
```
kubectl logs nginx-pod-01 -f
kubectl logs rc/nginx-rc

```
Kubectl Resource Requests & Limits
```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: demo
spec:
  hard:
    requests.cpu: 500m
    requests.memory: 100Mib
    limits.cpu: 700m
    limits.memory: 500Mib
```
Default Limit Range in a Namespace
```
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
spec:
  limits:
  - default:
      memory: 512Mi
    defaultRequest:
      memory: 256Mi
    type: Container
```
## A Pod that is run on a schedule
```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```

## ConfigMap
![image](https://github.com/user-attachments/assets/146e6df4-08a9-475c-91ce-769d465253d5)

Helm
* In simple terms, Helm is a package manager for Kubernetes![image](https://github.com/user-attachments/assets/94ed85a9-bc52-4490-8eb0-6fe109aecc8d)
```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | 
sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

```
   helm repo add stable https://charts.helm.sh/stable
   helm repo update
   helm search repo nginx
   helm install my-nginx stable/nginx
   helm list
```
