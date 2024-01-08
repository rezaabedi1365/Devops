#####  Playbook Conditional and Fact Variable 

* Fact condition
* Register Variable
* 
-----------------------------




### Fact Conditional
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/2d21fed6-cf60-4385-b4ae-0c3950af4b5f)
```
ansible all -m setup
ansible all -m setup -a "filter=*family*"
```

```
ansible_os_family == "Debian"
ansible_os_family == "RedHat"

ansible_distribution == "Ubuntu"
ansible_distribution == "CentOS"

ansible_pkg_mgr == "apt"

ansible_distribution_version == "22.04"
ansible_distribution_version|float >= 18

ansible_distribution_major_version == "22"
ansible_distribution_major_version|int >= 18
 

ansible_distribution_release == "jammy"
```
condition with sub fact
```
ansible_lsb.codename == "jammy"
ansible_python.version.major == 3
```


Example:
```
- name: playbook-Playbook Conditional
  hosts: all
  become: yes

  tasks:
    - name: Remove Apache on ubuntu Servers
      apt: name=apache2 state=absent
      when:
        - ansible_os_family == "Debian"

     - name: Remove Apache on Centos Servers
       apt: name=httpd state=absent
       when: ansible_os_family == "RedHat" and ansible_lsb.major_release|int >= 6
```
```
tasks:
  - command: /bin/false
    register: result
    ignore_errors: True

  - command: /bin/something
    when: result is failed

  # In older versions of ansible use ``success``, now both are valid but succeeded uses the correct tense.
  - command: /bin/something_else
    when: result is succeeded

  - command: /bin/still/something_else
    when: result is skipped

```
### Register Variable
Example :
check passwd file . if user reza dosnot exist then creat it
```
- name: check registered variable for emptiness
  hosts: lpic2-02
  tasks:
      - name: list contents of directory
        command: ls /etc/passwd
       #command: grep -e "reza" /etc/passwd
        register: Register_Name

      - name: check contents for emptiness
        command: useradd -G sudo -p 123456aA2044  -m reza -s /bin/bash
       #shell:

        when: Register_Name.stdout.find('reza') != 1  # if not exist
                                                  # != -1  # if exist
```
check /etc/apt if keyrings directory dosnot exited then create it
```
- name: check registered variable for emptiness
  hosts: lpic2-02

  tasks:
      - name: list contents of directory
        command: ls /etc/apt/
        register: Register_Name

      - name: check contents for emptiness
        command: mkdir -p /etc/apt/keyrings
       #shell: mkdir -p /etc/apt/keyrings

        when: Register_Name.stdout.find('keyrings') != 1  # if not exist
                                                  # != -1  # if exist

```
```
- name: check registered variable for emptiness
  hosts: all

  tasks:

      - name: list contents of directory
        command: ls mydir
        register: contents

      - name: check contents for emptiness
        debug:
          msg: "Directory is empty"
        when: contents.stdout == ""
```
```
- name: registered variable usage as a loop list
  hosts: all
  tasks:

    - name: retrieve the list of home directories
      command: ls /home
      register: home_dirs

    - name: add home dirs to the backup spooler
      file:
        path: /mnt/bkspool/{{ item }}
        src: /home/{{ item }}
        state: link
      loop: "{{ home_dirs.stdout_lines }}"
      # same as loop: "{{ home_dirs.stdout.split() }}"
```
