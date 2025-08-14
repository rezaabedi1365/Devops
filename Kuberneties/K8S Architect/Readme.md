
### Kube-system Namespace on Master
- etcd-master1
- kube-controller-manager-master1
- kube-apiserver-master1
- kube-scheduler-master1
- kube-calico
  
### Kube-system Namespace on Worker
- coredns ( 2 core for all architechtur)
- kube-proxy 
- kube-calico

### kubelet
```
systemctl status kubelet
```

### Kubectl and Kubeadm
```
kubectl version
kubeadm version
```
