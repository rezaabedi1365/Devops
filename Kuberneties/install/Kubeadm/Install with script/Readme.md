## Tshoot
```
dpkg -l | grep kube
dpkg -l | grep containerd
```
### Containerd
- check conteinerd service
```
systemctl status containerd
```
- check containerd path
    * /user/bin/conteinerd
```
which containerd
```
----------------------------------------------------------------------
###  kubectl

- check kubectl path
    * /user/bin/kubectl
```
which kubectl
```
```
kubectl version --cllient
```


- check cluster conectivity 
```
kubectl version
```

-----------------------------------------------------------------------
### kubelet
- check kubelet service
```
systemctl status kubelet
```
- check kubelet path
    * /user/bin/kubelet
```
which kubelet
```

-----------------------------------------------------------------------
### kubeadm
- check kubeadm path
    * /user/bin/kubeadm
```
which kubeadm
```
----------------------------------------------------------------------
### Config file
- check config file path
```
$HOME/.kube/config
```
--------------------------------------------------------------------
sudo swapon --show
