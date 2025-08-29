### On all nodes (Master and Worker):

* **kubeadm** → the main tool for setting up and managing the cluster.
* **kubelet** → the primary service on each node that runs the pods.
* **kubectl** → the command-line tool for managing the cluster
:x: (usually installed only on the control plane, but it can be installed on any system).
* **A container runtime** like `containerd` or `CRI-O` (Docker was used in the past, but now `containerd` or `CRI-O` is preferred).
-----------------------------------------------------------------------
### Kube-system Namespace on Master
- etcd-master1
- kube-controller-manager-master1
- kube-apiserver-master1
- kube-scheduler-master1
- kube-calico
  
### Kube-system Namespace on Worker
- coredns ( 2 core for all architechtur)
- kube-proxy
    * use for releation betwen cluster nods and masters
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

# verify:
```
kubectl cluster-info
```

```
kubectl get nodes
kubectl get nodes -o wide
kubectl describe nodes
```

```
kubectl get pods -A
kubectl get pods -A -o wide
```

```
kubectl get ns
kubectl get namespace
```

```
kubectl get svc
```

