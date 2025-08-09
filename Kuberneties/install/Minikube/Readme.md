# Install Minikube
```
#!/bin/bash
set -e

### step1 ) prerequisites

# install requirement
echo "-------------Installing requirement-------------"
sudo apt-get install -y apt-transport-https ca-certificates curl

# Set hostname
echo "-------------Setting hostname-------------"
hostnamectl set-hostname Minikube


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

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


### step2) Install Docker
#https://docs.docker.com/engine/install/ubuntu/
echo "-------------Installing docker-------------"
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

   
### Step 3) Install kubectl 
echo "-------------Installing Kubectl-------------"
#https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


### Step 4) Install Minikube 
echo "-------------Installing Mikukube-------------"
#https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube 

minikube start


### Step 5) Start your cluster 
minikube start --driver=docker --force

   
### Step 6) Enable addons 
minikube addons enable ingress 
minikube dashboard
minikube addons enable dashboard
minikube addons list 


### verify :
minikube status
kubectl get nodes
kubectl cluster-info

### Try to deploy a sample nginx deployment, run following set of commands.
kubectl create deployment nginx-web --image=nginx
kubectl expose deployment nginx-web --type NodePort --port=80
kubectl get pods
kubectl get deployment,pod,svc

### Kubectl Bash Auto Completion
apt-get install bash-completion
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
bash -l

```
