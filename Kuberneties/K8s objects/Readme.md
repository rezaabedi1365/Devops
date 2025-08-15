### Command

- kubectl exec
```
kubectl exec -n <NameSpace> -it <PodName> -- /bin/bash

kubectl exec -n <NameSpace> -it <PodName> -- nslookup google.com
kubectl exec -n <NameSpace> -it <PodName> -- cat /etc/resolv.conf
```
- kubectl cp
```
kubectl cp <source> <destination>

# cp pod to local
kubectl cp <namespace>/<pod-name>:<localpath>
kubectl cp mynamespace/my-pod:/var/log ./pod-logs

#cp local to pod
kubectl cp <localpath>:<namespace>/<pod-name>
kubectl cp ./config.yaml mynamespace/my-pod:/etc/config/config.yaml

```

