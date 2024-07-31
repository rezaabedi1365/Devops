

# Creating Highly Available Clusters with kubeadm
method 1)
```
kubeadm init --control-plane-endpoint "10.10.12.22" --upload-certs --pod-network-cidr 10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock
```
method 2)
```
kubeadm init phase upload-certs --upload-certs
kubeadm init --control-plane-endpoint "10.10.12.22"  --certificate-key $KEY_FROM_STEP1 --pod-network-cidr 10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock
```
```
kubeadm token list
kubeadm token create --print-join-command
```
# Kubectl Bash Auto Completion
apt-get install bash-completion
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
bash -l

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
