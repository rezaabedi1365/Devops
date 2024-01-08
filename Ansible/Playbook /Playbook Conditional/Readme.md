#####  Playbook Conditional and Fact Variable 
-----------------------------
### Fact Variable
```
ansible all -m setup
ansible all -m setup -a "filter=*family*"
```
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/2d21fed6-cf60-4385-b4ae-0c3950af4b5f)

### Playbook Conditional
```
- name: playbook-Playbook Conditional
  hosts: all
  become: yes

  tasks:

  - name: Remove Apache on ubuntu Servers
    apt: name=apache2 state=absent
    when: ansible_of_family="Debian"

  - name: Remove Apache on Centos Servers
    apt: name=httpd state=absent
    when: ansible_of_family="RedHat"
```
