
# Ansible
-------------------------------------
### ansible-config
Default path : /etc/ansible/ansible.cfg
-------------------------------------
Generating a sample ansible.cfg file
```
ansible-config init --disabled > ansible.cfg
```
```
ansible-config init --disabled -t all > ansible.cfg
```
### ansible inventory
Default path : /etc/ansible/host
------------------------------------------
```
ansible-inventory -i inventory --list
```
```
ansible-inventory -i /etc/ansible/hosts/ --list
```




