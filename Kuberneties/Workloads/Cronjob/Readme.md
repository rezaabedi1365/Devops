CronJobs within Kubernetes use UTC OLNY

![image](https://github.com/user-attachments/assets/c7f9b2dd-2d23-497b-8ad4-99bfb4ce1368)

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


