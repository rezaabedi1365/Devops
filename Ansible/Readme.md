
# Ansible
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/f5a4f0ea-77a8-43c1-aa8f-df370e6634cf)

---------------------------
## files
* /etc/ansible/hosts         – Default inventory file

* /etc/ansible/ansible.cfg   – Config file, used if present

* ~/.ansible.cfg             – User config file, overrides the default config if present

## ansible Command
- Addhoc  
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
check inventory availability
```
ansible all -m ping
```


### ansible Playbook
- Playbook Modules
- Playbook Conditionals
- Playbook Loops
- Playbook Vault 
-----------------------------------------
- Playbook tasks
   * [Module apt](####rd)
   * [Module yum]()
   * [Module Copy]()
   * [Module lineinfile]()
   * [Module service]()
   * [Module script]()
   * [Module iptables]()
   * [Module firewalld]()
   * [Module EMail]()
- Playbook Handlers

----------------------------------------------------------------
Run Playbook
```
ansible-playbook playbook1.yml
ansible-playbook playbook1.yml -yy
```
##### Module get_url
```
- name: Download ElasticSearch
  get_url:
    url: [http://example.com/path/file.deb](https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-{{ elasticsearch_version }}.tar.gz)
    dest: /vagrant 
  delegate_to: localhost
  run_once: yes
```
##### Module command
```
- name: Extract ElasticSearch files
  command: tar zxvf elasticsearch-{{ elasticsearch_version}}.tar.gz chdir=/vagrant creates=/vagrant/elasticsearch-{{ elasticsearch_version }}.
```
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
##### Module apt key
```
- name: Add key for Postgres repo
  apt_key: url=https://www.postgresql.org/media/keys/ACCC4CF8.asc state=present
  sudo: yes
```
##### Module apt repository
```
- name: Add Postgres repo to sources list
  apt_repository: repo='deb http://apt.postgresql.org/pub/repos/apt/ {{ distro }}-pgdg main' state=present
  sudo: yes
```
##### Module yum
```
  name: Install package(s) using yum
  hosts: centos
  become: yes
  tasks:
    - name: Install Apache & Postgresql
      yum:
        name:
          - httpd
          - postgresql
          - psotgresql-server
        state: present

    - name: Install apache >= 2.4
      yum:
        name: httpd>=2.4
        state: present
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
##### Module service
```
- name: Start some Services in order
  hosts: centos
  become: yes
  tasks:
    - name: Start the database service
      service:
         name: postgresql
         state: started
         enabled: yes

    - name: Start the httpd service
      service: name=httpd state=started enabled=yes
```
##### Module script
 ```
  name: Play Scripts
  hosts: centos
  become: yes
  tasks:
    - name: Run a script on remote server
      script: /home/user1/demo-module/script.sh
```
##### Module iptables
```
- hosts: dbservers
  tasks:
  - name: Allow access from 10.0.0.1
    ansible.builtin.iptables:
      chain: INPUT
      jump: ACCEPT
      source: 10.0.0.1
```
##### Module firewalld
```
- name: Set Firewall Configurations
  hosts: centos
  become: yes

  tasks:
    -  firewalld:
         service: https
         permanent: true
         state: enabled
    
    -  firewalld:
         port: 8080/tcp
         permanent: true
         state: disabled
                  
    -  firewalld:
         source: 192.168.100.0/24
         zone: internal
         state: enabled 
```
##### Module EMail
```
  name: sending mail 
  hosts: localhost
  tasks:
    - name: sending mail to root
      mail:
         subject: 'System has been successfully configured'
      delegate_to: localhost
       
    - name: Sending an e-mail using Gmail SMTP servers
      mail:
        host: smtp.gmail.com
        port: 587
        username: ansible@sematec.com
        password: mysecret
        to: John Smith <john.smith@example.com>
        subject: Ansible-report
        body: 'System has been successfully provisioned.'
      delegate_to: localhost
```
##### Module Handler
```
- name: Start some Services in order with handlers
  hosts: centos
  become: yes
//tasks:
//  - name: Start the httpd service
//    service: name=httpd state=started enabled=yes
  handlers:
    - name: start vsftpd
      service: name=vsftpd enabled=yes state=started
```


