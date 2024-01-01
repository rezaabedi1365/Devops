# ansible Roles  
-------------------------------------
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/72a4865f-54ba-4f67-9711-78d93e5e8285)
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/66a651c8-4281-4529-a0bc-9aeb9f06ba72)





### Run role
cd /etc/ansible/roles/
```
- name: system hardening
  hosts: all
  become: yes
  roles:
    - role_name
```
```
ansible-playbook role_name.yml
```

## Download from git_repo
```
git clone <git_repo_url> 
```
```
git clone <git_repo_url> <your_custom_directory_name>
```
```
git clone <git_repo_url> <your_custom_directory_name> / <sub_directory>
```
