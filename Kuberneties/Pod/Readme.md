# Pods
- Create pod with kubectl
- Create pod with yaml
- Create pod with Helm

## Create pod with kubectl
```
kubectl run test-nginx --image=nginx

kubectl create deployment nginx-web --image=nginx
kubectl expose deployment nginx-web --type NodePort --port=80
kubectl exec -it task-pv-pod -- /bin/bash
```

## Create pod with yaml
- YAML Generator 
  * https://gimlet.io/k8s-yaml-generator
  * https://k8syaml.com/

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-meta          #pod name
spec:
  containers:
  - name: nginx-con         #container-name
    image: nginx:1.14.2
    ports:
    - containerPort: 80
      protocol: TCP
```

```
kubectl create -f pod.yml
kubectl apply -f pod,yml
```

- delete pod
```
kubectl delete pods <podName> --force
```
- verify:
```
kubectl get pods -A 
kubectl get pods <PodName> -o wide
kubectl get pods <PodName> -o yaml
kubectl describe pod <PodName>
```


------------------------------------------------------------------------------------------------------------------
# limit Resource

- Resource Requests & Limits
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
```
kubectl create -f pod.yml
kubectl apply -f pod,yml
```
- Default Limit Range in a Namespace
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
```
kubectl create -f pod.yml
kubectl apply -f pod.yml
```

# A Pod that is run on a schedule
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
