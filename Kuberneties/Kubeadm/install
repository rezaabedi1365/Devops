https://github.com/kunchalavikram1427/kubernetes_using_kubeadm_with_terraform_on_aws/blob/master/master.sh



https://www.cherryservers.com/blog/install-kubernetes-on-ubuntu 
https://phoenixnap.com/kb/install-kubernetes-on-ubuntu 

 
Step 1) prerequisites 

$sudo apt-get install -y apt-transport-https ca-certificates curl 

##Assign Unique Hostname for Each Server Node and Edit /etc/hosts file 
$hostnamectl hostname master 
$hostnamectl hostname worker1 

##Disable all swap spaces with the swapoff command 
$sudo swapoff -a 
$sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
 
##Set up the IPV4 bridge on all nodes 
https://www.cherryservers.com/blog/install-kubernetes-on-ubuntu 

echo "-------------Setting IPTables-------------"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter

EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
modprobe br_netfilter
sysctl -p /etc/sysctl.conf

 
Step2) Install Container Runtimes 
https://github.com/containerd/containerd/blob/main/docs/getting-started.md 
https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/install-containerd-on-ubuntu-22-04.html 

# Install Containerd
echo "-------------Installing Containerd-------------"
wget https://github.com/containerd/containerd/releases/download/v1.7.4/containerd-1.7.4-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.7.4-linux-amd64.tar.gz
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mkdir -p /usr/local/lib/systemd/system
mv containerd.service /usr/local/lib/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

# Install Runc
echo "-------------Installing Runc-------------"
wget https://github.com/opencontainers/runc/releases/download/v1.1.9/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

# Install CNI
echo "-------------Installing CNI-------------"
wget https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.2.0.tgz

# Install CRICTL
echo "-------------Installing CRICTL-------------"
VERSION="v1.28.0" # check latest version in /releases page
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOF

   

 Step 3) Install K8s  
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/ 
https://pwittrock.github.io/docs/tasks/tools/install-kubectl/ 

#add k8s repository 
#sudo apt-get update 
sudo apt-get install -y kubelet kubeadm kubectl 
 

#sudo apt-mark hold kubelet kubeadm kubectl 

 

Verify: 

#Kubeadm version 

#kubectl version 

#kubectl get namespace 

#Kubelet version 

Configuring a cgroup driver 

 

 

  

Step 4) Initialize the Kubernetes cluster on the master node 

#sudo kubeadm config images pull 

#sudo kubeadm init --pod-network-cidr=10.10.12.0/24 

 

#mkdir -p $HOME/.kube 

#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 

#sudo chown $(id -u):$(id -g) $HOME/.kube/config 

 

  

Step 5) Configure kubectl and Calico 

https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises 

 

Run the following commands on the master node to deploy the Calico operator. 

#kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml 

#sed -i 's/cidr: 192\.168\.0\.0\/16/cidr: 10.10.0.0\/16/g' custom-resources.yaml 

#kubectl create -f custom-resources.yaml 

#watch kubectl get pods -n calico-system 

  

Step 6) Add worker nodes to the cluster 

#sudo kubeadm join &lt;MASTER_NODE_IP>:&lt;API_SERVER_PORT> --token &lt;TOKEN> --discovery-token-ca-cert-hash &lt;CERTIFICATE_HASH> 
