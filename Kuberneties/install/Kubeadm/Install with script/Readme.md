## Tshoot
-check conteinerd service
```
systemctl status containerd
```
- check containerd path
    * /user/bin/conteinerd
```
which containerd
```
----------------------------------------------------------------------
- check kubectl
```
kubectl version --cllient
```
- check cluster conectivity 
```
kubectl version
```

-----------------------------------------------------------------------
- check kubelet service
```
systemctl status kubelet
```


-----------------------------------------------------------------------
- check config file path
```
$HOME/.kube/config
```
