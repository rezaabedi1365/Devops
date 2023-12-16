##### Playbook Loops
```
- name: playbook-apt
  hosts: all
  become: yes

  tasks:
  - name: Install package
    apt: [ 'vim' , 'nginx' , 'xrdp' ]
    update_cache= yes
    state= present
    
  - name: Install package
    apt: name={{item}} update_cache=yes state=present
    with_items:
    - vim
    - nginx
    - xrdp
```

