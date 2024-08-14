* Replicaset
* Deployment
* DaemonSet
* StatefulSet
* Job
* CronJob

## Replicatset
```
apiVersion: v1
kind: ReplicaSet
metadata:
  name: Replica-1        
spec:
  Replicas: 3
  selector:
    matchLabels:
      app: nginx
      env: prod
  template:
    <pod template>
```

