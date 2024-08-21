https://artifacthub.io/


install 
*  https://helm.sh/docs/intro/install/

```
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update
sudo apt-get install helm
helm repo add stable https://charts.helm.sh/stable
```
verify:
```
helm version
```

add repo to helm
```
# add first repo
helm repo add stable https://charts.helm.sh/stable
# add second repo
helm search hub ingress-nginx
helm repo add ingress-nginx https://github.com/kubernetes/ingress-nginx

helm repo update
```

search in repolist
```
helm search repo ingress-nginx
```

Unistall Helm
```
helm list; helm uninstall my-release
```

![image](https://github.com/user-attachments/assets/33944cad-2363-4c1f-8ea4-afe8016393d8)

