#7) Set up kubeconfig as normal ubuntu user
#exit root as normal user

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#to verify, if kubectl is working or not, run the following command.
kubectl get pod -A
