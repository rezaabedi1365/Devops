# Job
* backoffLimit
* completions
* parallelism
* spec.template.spec.restartPolicy

  -------------------------------------------------------------------------------------------
you can impelemnt job or command with this workload
```
apiVersion: batch/v1
kind: Job
metadata:
  name: job-example
spec:
  backoffLimit: 4
  completions: 4
  parallelism: 2
  template:
    spec:
      containers:
      - name: hello
        image: alpine:latest
        command: ["/bin/bash", "-c"]
        args: ["echo hello from $HOSTNAME"]
      restartPolicy: Never

```
Delete job 
```
kubectl delete job job-example
```
verify:
```
kubectl get jobs
kubectl get pods
```
