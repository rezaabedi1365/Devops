#!/bin/bash
set -e
### step1 ) prerequisites
#Dont use root account . Create soduer user with root access 

# Set hostname
echo "-------------Setting hostname-------------"
sudo hostnamectl set-hostname master
#set /etc/hosts file and vrify it from ping 

echo "-------------Install Requirement-------------"
sudo apt-get install -y apt-transport-https ca-certificates curl

# Disable swap
echo "-------------Disabling swap-------------"
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapon --show


# Forwarding IPv4 and letting iptables see bridged traffic
echo "-------------Setting IPTables-------------"
sudo cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

### step2) Install Containerd
echo "-------------Installing Containerd-------------"
#sudo apt-get install -y containerd.io
sudo apt install -y docker.io

#Create a containerd configuration file
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

#sudo usermod -aG docker $USER

### Step3) Install kubectl, kubelet and kubeadm
echo "-------------Installing Kubectl, Kubelet and Kubeadm-------------"
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

echo "-------------Pulling Kueadm Images -------------"
sudo kubeadm config images pull
#kubeadm config images list

echo "-------------Running kubeadm init-------------"
sudo kubeadm init --pod-network-cidr=10.10.12.0/24

echo "-------------Copying Kubeconfig-------------"
sudo mkdir -p /$HOME/.kube
sudo cp -iv /etc/kubernetes/admin.conf /$HOME/.kube/config
sudo chown $(id -u):$(id -g) /$HOME/.kube/config

echo "-------------Deploying Calico Pod Networking-------------"
sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
sudo curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml -O
sudo sed -i 's/cidr: 192\.168\.0\.0\/16/cidr: 10.10.12.0\/24/g' custom-resources.yaml
sudo kubectl create -f custom-resources.yaml 








 
