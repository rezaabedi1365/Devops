
# Ansible
- [ansible-config]()
- [ansible inventory]()
- [ansible Playbook]()
[Playbook Conditionals]()
- [ansible Roles]()
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
- Playbook Conditionals
- Playbook Loops
- Playbook Vault 
-----------------------------------------
* [Module apt](####rd)
* [Module Copy]()
* [Module lineinfile]()
* [Module firewalld]()
* [Module EMail]()

----------------------------------------------------------------
##### Module apt
```
ansible
```
##### Module Copy
```
ansible
```
##### Module lineinfile
```
ansible
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
