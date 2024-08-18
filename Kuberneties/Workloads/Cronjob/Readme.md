CronJobs within Kubernetes use UTC OLNY
* https://medium.com/@muppedaanvesh/a-hand-on-guide-to-kubernetes-cronjobs-%EF%B8%8F-47393a98716d

* schedule
* successfulJobHistoryLimit
* failedJobHistoryLomit

  

![image](https://github.com/user-attachments/assets/c7f9b2dd-2d23-497b-8ad4-99bfb4ce1368)

1. Basic CronJobs
```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: basic-cronjob
spec:
  schedule: "*/1 * * * *"  # Run every 1 minutes
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: basic-container
            image: busybox
            command: ["echo", "Hello from the basic CronJob"]
          restartPolicy: Never

```
2. Job History Limits CronJobs
```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: history-limit-cronjob
spec:
  schedule: "*/1 * * * *"  # Run every 1 minutes
  successfulJobsHistoryLimit: 2  # Retain up to 2 successful Job completions
  failedJobsHistoryLimit: 1  # Retain only the latest failed Job completion
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: history-limit-container
            image: busybox
            command: ["echo", "Hello from the history-limit CronJob"]
          restartPolicy: Never
      
```
3. Concurrency Policy CronJobs
```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: concurrency-cronjob
spec:
  schedule: "*/1 * * * *"  # Run every 1 minutes
  concurrencyPolicy: Forbid  # Do not allow concurrent executions
  # Allowed Values are
  # : Allow (default)
  # : Forbid
  # : Replace
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: concurrency-container
            image: busybox
            command: ["echo", "Hello from the concurrency CronJob"]
          restartPolicy: Never
```

verify:
```
kubectl describe cronjob history-limit-cronjob
```

Deleting a CronJob
```
kubectl delete cronjob hello
```
