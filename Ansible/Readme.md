
# Ansible
---------------------------
- ansible-config
- ansible inventory
- ansible Playbook
    * Playbook Modules
    * Playbook Conditionals
    * Playbook Loops
    * Playbook Vault
- ansible Roles
-------------------------------------
### ansible-config
###### Default path : /etc/ansible/ansible.cfg
-------------------------------------
Generating a sample ansible.cfg file
```
ansible-config init --disabled > ansible.cfg
```
```
ansible-config init --disabled -t all > ansible.cfg
```
### ansible inventory

###### Default path : /etc/ansible/host
----------------------------------
```
ansible-inventory  --list 
```
Spesefic inventory
```
ansible-inventory -i /etc/ansible/invent01.yml --list
```
### ansible Playbook
- Playbook Modules
- Playbook Conditionals
- Playbook Loops
- Playbook Vault 
-----------------------------------------
Playbook tasks
* [Module apt](####rd)
* [Module Copy]()
* [Module lineinfile]()
* [Module firewalld]()
* [Module EMail]()
Playbook Handlers

----------------------------------------------------------------
##### Module apt
```
- name: playbook-apt
  hosts: all
  become: yes

  tasks:
    apt:
      name: nginx
      state: present
      update_cache: present
      ignore_error: yes

  - name: Add diodon repository
    apt_repository: repo=ppa:diodon-team/stable

  - name: Install package
    apt: name={{item}} state=present
    with_items:
    - vim
    - nginx
    - xrdp

  - name: Remove Apache on ubuntu Servers
    apt: name=apache2 state=absent
    wihen: ansible_of_family="Debian"

  - name: Remove Apache on Centos Servers
    apt: name=httpd state=absent
    wihen: ansible_of_family="RedHat"

```
##### Module Copy
```
- name: playbook-copy
  hosts: all
  become: yes

  tasks:
    - name: copy file
      copy:
        src: /etc/ssh/sshd_config
        dst: /root/backup
        owner: root
        group: root
        mode: 0755
        backup: yes
        
```
##### Module lineinfile
```
- name: playbook-lineinfile
  hosts: all
  become: yes

  tasks:
    - name: add sheken DNS server
      lineinfile:
        path: /etc/resolv.conf
        line: 'nameserver: 178.22.122.100'

    - name: Changing root login permit
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: "PrtmitRootLogin"
        state: absent
        line: 'PermitRootLogin yes'
        backup: yes
```

##### Module firewalld
```
ansible
```
##### Module EMail
```
ansible
```
### ansible Roles  
-------------------------------------
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/66947d81-9aca-4f77-b79e-f2f487985aa0)
