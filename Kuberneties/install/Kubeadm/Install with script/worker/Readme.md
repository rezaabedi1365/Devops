# worker
- use other user and dont user root user
```
#!/bin/bash
set -e

echo "-------------Setting hostname-------------"
# تنظیم hostname دلخواه برای نود کلاینت
sudo hostnamectl set-hostname worker-node

echo "-------------Disabling Swap-------------"
sudo swapoff -a
sudo sed -i '/swap/ s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapon --show

echo "-------------Configuring sysctl for Kubernetes-------------"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

echo "-------------Installing containerd-------------"
sudo apt-get update
sudo apt-get install -y ca-certificates curl apt-transport-https

# اضافه کردن کلید GPG رسمی داکر
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# اضافه کردن مخزن داکر برای نصب containerd
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y containerd.io

# پیکربندی containerd برای systemd cgroup
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

echo "-------------Installing kubeadm, kubelet, kubectl v1.33.3-------------"
sudo apt-get update

# اضافه کردن کلید و مخزن Kubernetes نسخه 1.33
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

```
# verify 
```
kubeadm version
kubelet --version
kubectl version --client

sudo systemctl status kubelet

### not work in worker
kubectl get nodes
kubectl get pods --all-namespaces
journalctl -u kubelet -f
```
# Token
```
# in server run
kubeadm token create --print-join-command
```
- run with root user
```
echo "-------------Joining the Kubernetes cluster-------------"
# دستور join را جایگزین دستور نمونه زیر کنید (با توکن و hash متناسب با مستر خود)
sudo kubeadm join 10.10.12.22:6443 --token shmky1.6pagk5qwxf420bny --discovery-token-ca-cert-hash sha256:bb5bf288811c38117ff439e6db4d372e7d357d558d33aaafc9094471afca22f4

echo "-------------Node joined to cluster successfully-------------"
```
