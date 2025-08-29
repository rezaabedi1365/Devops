# Pods
- Create pod with kubectl
- Create pod with yaml
- Create pod with Helm

## Create pod with kubectl
```
kubectl run test-nginx --image=nginx

kubectl create deployment nginx-web --image=nginx
kubectl expose deployment nginx-web --type NodePort --port=80
```
```
kubectl exec -it -n <Namespace> <pod-name> -- <command>
kubectl exec -it -n <Namespace> <pod-name> -- /bin/bash
kubectl exec -it -n <Namespace>/<pod-name> -- /bin/bash
```
```
kubectl cp file1.txt <Namespace>/<pod-name>:/path
kubectl cp file1.txt zabbix/nginx-pod:/tmp
```

## Create pod with yaml
- YAML Generator 
  * https://k8s-examples.container-solutions.com/
  * https://gimlet.io/k8s-yaml-generator
  * https://k8syaml.com/

```
apiVersion: v1
kind: Pod
metadata:                  #information
  name: nginx-pod          #pod name
  namespace: zabbix-NS
  label:
    app: zabbix
spec:
  containers:
  - name: nginx-cont        #container-name
    image: nginx:1.14.2
    ports:
    - containerPort: 80
      protocol: TCP
```
- :x: key: value (Map/Dictionary)
- :x: item (list)
```
kubectl create -f pod.yml
kubectl apply -f pod,yml
```

:heavy_check_mark: create Namespace and pod 
```
apiVersion: v1
kind: Namespace
metadata:                  
  name: zabbix-NS       

---
apiVersion: v1
kind: Pod
metadata:                  #information
  name: nginx-pod          #pod name
  namespace: zabbix-NS
  label:
    app: zabbix
spec:
  containers:
  - name: nginx-cont        #container-name
    image: nginx:1.14.2
    ports:
    - containerPort: 80
      protocol: TCP
```

- delete pod
```
kubectl delete pods <podName> --force
```
- verify:
```
kubectl get pods 
kubectl get pods -o wide
kubectl get pods -o yaml
```
```
kubectl get pods <PodName>
kubectl get pods <PodName> -o wide
kubectl get pods <PodName> -o yaml
kubectl describe pod <PodName>
```
```
kubectl get pods -A
kubectl get pods -o wide -A
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
