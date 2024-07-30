

```

# Creating Highly Available Clusters with kubeadm
```
sudo kubeadm init --control-plane-endpoint "10.10.12.22" --upload-certs --pod-network-cidr 10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock
kubeadm token create --print-join-command
```

# Delete Flannel
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
