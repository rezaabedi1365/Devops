Create /etc/kubernetes/kubelet.conf and /etc/kubernetes/pki/ca.crt
```
kubeadm join 10.10.12.22:6443 --token oj7xjf.5p2wx0l2ygdfu9hy --discovery-token-ca-cert-hash sha256:bb5bf288811c38117ff439e6db4d372e7d357d558d33aaafc9094471afca22f4
```


```
kubeadm reset
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /run/flannel
rm -rf /etc/cni/
ifconfig cni0 down
brctl delbr cni0
ifconfig flannel.1 down
systemctl start docker

ip link delete cni0
ip link delete flannel.1
```