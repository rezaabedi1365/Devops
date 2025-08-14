[Mul](https://github.com/arashforoughi/Multi-Master-Cluster-in-Kubernetes

# kubeadm init --control-plane-endpoint "192.168.44.137:6443" --upload-certs --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address 192.168.44.137

# kubeadm join 192.168.44.137:6443 --token 6r0uef.3f1yycrzotyyny4i \
      --discovery-token-ca-cert-hash sha256:e57cbffd38f35ba6161f7e783d2198c14bb803d193a2bfcb7be36be9b0e979cc \
      --control-plane --certificate-key 70475e2d3e72765a13a1bacfd31ffe2cb905316abadeba6e1c0db4d0f7235900



# kubeadm init phase upload-certs --upload-certs
8801302dadf12348c59df41f990683095b191774bdd6750491015ff98a69fe98

# kubeadm token create --print-join-command
kubeadm join 192.168.10.100:6443 --token 354nd6.7tdroi4shmh6oasl \
    --discovery-token-ca-cert-hash sha256:956c3a94edfdbd470873150213d4d68fe14bbb66ba52471be7f38a01a7c44026 \
    --control-plane --certificate-key 8801302dadf12348c59df41f990683095b191774bdd6750491015ff98a69fe98
)

-------------------------------------------------------
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
