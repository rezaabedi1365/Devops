#!/bin/bash
set -e
### step1 ) prerequisites
#Dont use root account . Create soduer user with root access 

# Set hostname
echo "-------------Setting hostname-------------"
hostnamectl set-hostname master
#set /etc/hosts file and vrify it from ping 

echo "-------------Install Requirement-------------"
sudo apt-get install -y apt-transport-https ca-certificates curl

# Disable swap
echo "-------------Disabling swap-------------"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapon --show


# Forwarding IPv4 and letting iptables see bridged traffic
echo "-------------Setting IPTables-------------"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
modprobe br_netfilter
sysctl -p /etc/sysctl.conf

### step2) Install Containerd
echo "-------------Installing Containerd-------------"





### Step3) Install kubectl, kubelet and kubeadm
echo "-------------Installing Kubectl, Kubelet and Kubeadm-------------"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update -y
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo "-------------Pulling Kueadm Images -------------"
kubeadm config images pull

echo "-------------Running kubeadm init-------------"
kubeadm init

echo "-------------Copying Kubeconfig-------------"
mkdir -p /root/.kube
cp -iv /etc/kubernetes/admin.conf /root/.kube/config
sudo chown $(id -u):$(id -g) /root/.kube/config



 
