

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
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install gitlab-runner -y
```

```
gitlab-runner register  --url http://10.10.12.18  --token glrt-I2lmHY0dAwVt3Oauiapwr286MQpwOjIKdDozCnU6MQ8.01.1712fij8y
```
```
gitlab-runner run
```
- verify
```
sudo gitlab-runner status
```
