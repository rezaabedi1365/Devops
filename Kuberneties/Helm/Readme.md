```
helm status my-release
```
```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt install apt-transport-https -y
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update; sudo apt install helm
```
verify:
```
helm repo list
helm repo update
helm repo list
kubectl proxy
kubectl get pods
```
Unistall Helm
```
helm list; helm uninstall my-release![image](https://github.com/user-attachments/assets/08a14467-903d-4969-9081-80d76876f26e)
```