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
journalctl -u kubelet -f
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
### Calico
```
kubectl get pods -n kube-system -l k8s-app=calico-node
kubectl get pods --all-namespaces | grep calic
```
```
kubectl get daemonsets -n kube-system
```
----------------------------------------------------------------------
### Config file
- check config file path
```
$HOME/.kube/config
```
--------------------------------------------------------------------
- check swapon
```
sudo swapon --show
```
--------------------------------------------------------------------

### verify
```
kubectl get nodes
kubectl get namespaces

kubectl get pods --all-namespaces
kubectl get pods -n kube-system
```
