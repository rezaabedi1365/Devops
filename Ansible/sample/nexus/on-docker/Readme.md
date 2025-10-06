```
---
- name: نصب و اجرای Nexus Repository Manager 3 در Docker
  hosts: nexus_servers
  become: true
  vars:
    nexus_image: "sonatype/nexus3:latest"
    nexus_container_name: "nexus"
    nexus_port: 8081
    nexus_data_dir: "/opt/nexus-data"

  tasks:

    - name: اطمینان از نصب Docker
      apt:
        name: docker.io
        state: present
        update_cache: true

    - name: اطمینان از نصب پلاگین docker-compose
      apt:
        name: docker-compose-plugin
        state: present

    - name: ایجاد دایرکتوری داده‌های Nexus
      file:
        path: "{{ nexus_data_dir }}"
        state: directory
        owner: root
        group: root
        mode: '0755'

    - name: اجرای کانتینر Nexus
      community.docker.docker_container:
        name: "{{ nexus_container_name }}"
        image: "{{ nexus_image }}"
        state: started
        restart_policy: unless-stopped
        ports:
          - "{{ nexus_port }}:8081"
        volumes:
          - "{{ nexus_data_dir }}:/nexus-data"

    - name: انتظار برای آماده شدن Nexus (حدود 2 دقیقه)
      uri:
        url: "http://localhost:{{ nexus_port }}"
        status_code: 200
        validate_certs: no
      register: nexus_status
      retries: 30
      delay: 10
      until: nexus_status.status == 200

    - name: نمایش پیام موفقیت
      debug:
        msg: "✅ Nexus Repository Manager با موفقیت در Docker روی پورت {{ nexus_port }} اجرا شد!"
```
```
ansible-galaxy collection install community.docker
```
