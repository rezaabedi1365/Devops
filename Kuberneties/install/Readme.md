cp /etc/kubernetes/admin.conf ~/.kube/config

kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes
ls ~/.kube/config

create pod in master > when have error status pending
kubectl edit nodes ubuntu(master node name)
	taints: delete 3 lines
		
![image](https://github.com/user-attachments/assets/467455cb-d79e-46de-bf7d-a9aa5f4100f0)
