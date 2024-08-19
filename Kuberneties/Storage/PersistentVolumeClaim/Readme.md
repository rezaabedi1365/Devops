


```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-sc-example
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: slow
```
