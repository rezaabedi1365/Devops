# ansible Roles  
-------------------------------------
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/72a4865f-54ba-4f67-9711-78d93e5e8285)



### Run role
cd /etc/ansible/roles/
```
- name: system hardening
  hosts: all
  become: yes
  roles:
    - rule_name
