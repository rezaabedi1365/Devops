# https://www.youtube.com/watch?v=DrcS4jrA_no

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
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
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



### Step 10: Initialize the Cluster and Install CNI
sudo kubeadm config images pull
#sudo kubeadm init
## (flanel range 10.10.12.22) 
sudo kubeadm init --apiserver-advertise-address 10.10.12.22 --pod-network-cidr 10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock



echo "-------------Deploying Flannel Pod Networking-------------"
# https://kubernetes.io/docs/concepts/cluster-administration/addons/
kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.30/net.yaml

