## empryDir
```
apiVersion: v1
kind: Pod
metadata:
  name: volume-example
spec:
  containers:
    - name: nginx
      image: nginx: stable-alpine
      volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
          ReadOlny: true
    - name: content
      image: alpine:latest
      command: [bin/sh:,"-c"]
      args:
       - while true; do
          date>> /gtml/index.html
          sleep 5;
         done                
  volumes:
    - name: html
      configMap:
      emplyDir: {}
```
```
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: registry.k8s.io/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
  volumes:
  - name: cache-volume
    emptyDir:
      sizeLimit: 500Mi
```
