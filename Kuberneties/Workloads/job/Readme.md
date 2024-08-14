# Job
* backoffLimit
* completions
* parallelism
* spec.template.spec.restartPolicy

  -------------------------------------------------------------------------------------------

```
apiVersion: apps/v1
kind: Job
metadata:
  name: job-example

spec:
  backoffLimit: 4
  completions: 4
  parallelism: 2

  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        restartPolicy: Never
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
