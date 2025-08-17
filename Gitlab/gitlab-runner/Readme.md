## Gitlab Runner
:heavy_check_mark:  you can install some runer with diffrent exexuter type for each project . 
- for example for push project you can have one runner with kuberneties executer and one shell executer . for other project Likewise.
- GitLab Runner install on kube-master node
```
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install gitlab-runner -y
```
### Runner registery tag format Suggested

<project>-<executor>-<stage>-<master-number>
```
push-shell-deplpy-master1
push-kuberneties-deploy-master1
```
- method 1
- in this method have some questioin step aboue gitlab address , type of executer and name for runner
```
gitlab-runner register
```
<img width="1045" height="259" alt="image" src="https://github.com/user-attachments/assets/8910d611-37d0-4f8f-9e92-34ee70356db3" />

- method 2
```
gitlab-runner register  --url http://10.10.12.18  --token glrt-I2lmHY0dAwVt3Oauiapwr286MQpwOjIKdDozCnU6MQ8.01.1712fij8y
```

- verify
```
sudo gitlab-runner status
```
<img width="1067" height="526" alt="image" src="https://github.com/user-attachments/assets/efe05786-ff9b-4ea3-88af-bd66a5efeda4" />
