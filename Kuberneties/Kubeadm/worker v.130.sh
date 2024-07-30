#!/bin/bash
set -e
### Step 0: prerequisites
#Dont use root account . Create soduer user with root access 

# Set hostname
echo "-------------Setting hostname-------------"
sudo hostnamectl set-hostname master
#set /etc/hosts file and vrify it from ping 


### Step 1: Disable Swap on All Nodes
echo "-------------Disabling swap-------------"
sudo swapoff -a
sudo sed -i '/swap/ s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapon --show



### step 2: Install Containerd
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md
echo "-------------Installing Containerd-------------"
#Enable IPv4 packet forwarding
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
# Apply sysctl params without reboot
sudo sysctl --system

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install containerd.io
systemctl enable --now containerd

### Step 3: Modify containerd Configuration for systemd Support
containerd config default> /etc/containerd/config.toml

#manual action
#nano /etc/containerd/config.toml  
#[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#   SystemdCgroup = true
sudo systemctl restart containerd


### Step 4: Install kubeadm, kubelet, and kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


### Step 5: join to Cluster
kubeadm token create --print-join-command
kubeadm join 10.10.12.22:6443 --token shmky1.6pagk5qwxf420bny --discovery-token-ca-cert-hash sha256:bb5bf288811c38117ff439e6db4d372e7d357d558d33aaafc9094471afca22f4

