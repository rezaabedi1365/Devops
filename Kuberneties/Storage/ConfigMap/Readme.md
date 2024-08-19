## ConfigMap

```
kubectl create configmap file-example --from-file=ifo/city --from-file=info/state
```
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: manifest-example
data:
  city: Tehran
  state: Tehran
```

![image](https://github.com/user-attachments/assets/146e6df4-08a9-475c-91ce-769d465253d5)


