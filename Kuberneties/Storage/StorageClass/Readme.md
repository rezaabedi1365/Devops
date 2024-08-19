## StorageClass

```
apiVersion: v1
kind: StorageClass
metadata:
  name: standard
privisioner: kubernetes.io/gce-pd
parameters:
  type: pd-standard
  zone: us-centrall-a
reclaimPolicy: Delete
```

![image](https://github.com/user-attachments/assets/47a03c17-a8c7-4dc7-84be-434c84416e72)
