
# ansible Playbook
- Playbook Modules
- Playbook Conditionals
- Playbook Loops
- Playbook Vault 
-----------------------------------------
### Playbook Modules
   * [Module apt](####rd)
   * [Module yum]()
   * [Module Copy]()
   * [Module lineinfile]()
   * [Module service]()
   * [Module script]()
   * [Module firewalld]()
   * [Module EMail]()
### Playbook Handlers

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

    - name: copy some file
      copy:
        src: {{ item }}
        with_file:
          - file1.txt
          - file2.txt
        dst: /root/backup

    - name: Create text file
      copy:
        content: |
         hello
         my name is reza.
        dst: /root/scripts/text.txt
        owner: root
        group: root
        mode: 0755 
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

