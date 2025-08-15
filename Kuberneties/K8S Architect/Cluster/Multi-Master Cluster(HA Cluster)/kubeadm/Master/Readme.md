### Master
- use other user and dont use root user
```
#!/bin/bash
set -e

### Step 0: prerequisites
# توصیه: کاربر sudo با دسترسی روت ایجاد شود، استفاده از root مستقیم توصیه نمی‌شود.

# تنظیم hostname
echo "-------------Setting hostname-------------"
sudo hostnamectl set-hostname master

# مطمئن شوید خط مربوط به hostname در /etc/hosts تنظیم شده است

### Step 1: Disable Swap on All Nodes
echo "-------------Disabling swap-------------"
sudo swapoff -a
sudo sed -i '/swap/ s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapon --show

### Step 2: Install containerd 2.1.4
echo "-------------Installing containerd 2.1.4-------------"

# فعال کردن IPv4 forwarding
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# اضافه کردن کلید GPG رسمی داکر
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# اضافه کردن مخزن داکر
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y containerd.io=1.7.1-1  # توجه: جدیدترین نسخه موجود در مخزن رسمی (مطابق 2.1.4 نیست اما پایدار است)

# پیکربندی containerd برای systemd cgroup
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

### Step 3: Install kubeadm, kubelet, kubectl version 1.33.3
echo "-------------Installing Kubernetes 1.33.3-------------"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=1.33.3-00 kubeadm=1.33.3-00 kubectl=1.33.3-00
sudo apt-mark hold kubelet kubeadm kubectl

### Step 4: Initialize Kubernetes Cluster
### 192.168.0.0/24 cidr for calico &   10.244.0.0/16 cidr for Flannel
sudo kubeadm config images pull
kubeadm init \
  --control-plane-endpoint "<MasterIpAddress>:6443" \
  --upload-certs \
  --pod-network-cidr=192.168.0.0/16 \
  --apiserver-advertise-address <MasterIpAddress>


### user Pormission
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

### Step 5: Deploy CNI - Calico Pod Network
echo "-------------Deploying Calico Pod Networking-------------"
kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml

### Step 6: Enable kubectl bash completion and alias
sudo apt-get install -y bash-completion
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
bash -l

```
### verify 
```
kubeadm version
kubelet --version
kubectl version --client

sudo systemctl status kubelet

kubectl get nodes

kubectl get pods --all-namespaces
kubectl get pods -n kube-system

journalctl -u kubelet -f
```
### Token
```
kubeadm token list
kubeadm token create --print-join-command
```

# Reset cluster
```
sudo kubeadm reset
```
```
sudo rm -rf /etc/cni/net.d
```

```
sudo rm -rf ~/.kube
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /etc/kubernetes
```

```
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F
sudo iptables -X
```
Flannel
```
sudo ip link delete cni0
sudo ip link delete flannel.1
```
calico
```
sudo ip link delete cni0
sudo ip link delete tunl0         # اگر Calico روی IP-in-IP هست
sudo ip link delete vxlan.calico  # اگر Calico روی VXLAN هست
```
```
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```
