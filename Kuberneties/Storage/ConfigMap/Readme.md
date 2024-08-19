## ConfigMap
![image](https://github.com/user-attachments/assets/146e6df4-08a9-475c-91ce-769d465253d5)

Helm
* In simple terms, Helm is a package manager for Kubernetes![image](https://github.com/user-attachments/assets/94ed85a9-bc52-4490-8eb0-6fe109aecc8d)
```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | 
sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

```
   helm repo add stable https://charts.helm.sh/stable
   helm repo update
   helm search repo nginx
   helm install my-nginx stable/nginx
   helm list
```
