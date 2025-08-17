

## Gitlab-ce commounity Edition
- install gitlab-ce cumunity Edition
```
sudo apt update && sudo apt upgrade -y

sudo apt install -y curl openssh-server ca-certificates tzdata perl

curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash


sudo EXTERNAL_URL="http://10.10.12.18" apt install gitlab-ce -y

```

- root password path
```
cat /etc/gitlab/initial_root_password
```
- gitlab config
```
nano /etc/gitlab/gitlab.rb
```

## Gitlab Runner
- GitLab Runner install on kubet master node
```
sudo apt install gitlab-runner -y
sudo gitlab-runner register
```
```
sudo gitlab-runner status
```
