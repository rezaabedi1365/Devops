# Job
* backoffLimit
* completions
* parallelism
* spec.template.spec.restartPolicy

  -------------------------------------------------------------------------------------------

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
      restartPolicyt: Never

    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
