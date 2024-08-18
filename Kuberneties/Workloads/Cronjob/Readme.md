CronJobs within Kubernetes use UTC OLNY

* schedule
* successfulJobHistoryLimit
* failedJobHistoryLomit

  

![image](https://github.com/user-attachments/assets/c7f9b2dd-2d23-497b-8ad4-99bfb4ce1368)

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: cronjob-example
spec:
  schedule: "*/1 * * * *"
  successfulJobHistoryLimit: 3
  failedJobHistoryLimit: 1
  jobTemplate:
    spec:
      completions: 4
      parallelism: 2
      template:
        spec:
          containers:
          - name: hello2
            image: alpine:latest
            command: ["/bin/bash", "-c"]
            args: ["echo hello from $HOSTNAME"]
          restartPolicy: Never
      
```


