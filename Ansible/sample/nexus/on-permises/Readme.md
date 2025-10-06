```
roles/
└── nexus/
    ├── tasks/
    │   └── main.yml
    ├── handlers/
    │   └── main.yml
    ├── templates/
    │   └── nexus.service.j2
    ├── vars/
    │   └── main.yml
    └── README.md
```
inventory.ini
```
#nexus_servers همون گروهیه که در Playbook استفاده کردی
[nexus_servers]
192.168.1.50 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
```


vars/main.yml
```
# تنظیمات متغیرهای Nexus
nexus_version: "3.68.0-04"
nexus_user: "nexus"
nexus_group: "nexus"
nexus_install_dir: "/opt/nexus"
nexus_data_dir: "/opt/sonatype-work/nexus3"
nexus_download_url: "https://download.sonatype.com/nexus/3/nexus-{{ nexus_version }}-unix.tar.gz"
```
tasks/main.yml
```
---
# وظایف نصب و پیکربندی Nexus Repository Manager 3

- name: اطمینان از نصب Java 11
  apt:
    name: openjdk-11-jre
    state: present
    update_cache: true

- name: ایجاد گروه nexus
  group:
    name: "{{ nexus_group }}"
    state: present

- name: ایجاد کاربر nexus
  user:
    name: "{{ nexus_user }}"
    group: "{{ nexus_group }}"
    shell: /bin/bash
    home: "{{ nexus_install_dir }}"
    create_home: no
    system: yes

- name: اطمینان از وجود مسیرهای Nexus
  file:
    path: "{{ item }}"
    state: directory
    owner: "{{ nexus_user }}"
    group: "{{ nexus_group }}"
    mode: '0755'
  loop:
    - "{{ nexus_data_dir }}"

- name: دانلود فایل نصب Nexus
  get_url:
    url: "{{ nexus_download_url }}"
    dest: "/tmp/nexus-{{ nexus_version }}.tar.gz"
    mode: '0644'

- name: استخراج آرشیو Nexus
  unarchive:
    src: "/tmp/nexus-{{ nexus_version }}.tar.gz"
    dest: /opt/
    remote_src: true
    creates: "/opt/nexus-{{ nexus_version }}"

- name: ساخت لینک نمادین برای nexus
  file:
    src: "/opt/nexus-{{ nexus_version }}"
    dest: "{{ nexus_install_dir }}"
    state: link
    force: true

- name: تغییر مالکیت دایرکتوری‌ها
  file:
    path: "{{ item }}"
    owner: "{{ nexus_user }}"
    group: "{{ nexus_group }}"
    recurse: yes
  loop:
    - "{{ nexus_install_dir }}"
    - "{{ nexus_data_dir }}"

- name: تنظیم run_as_user در nexus.rc
  lineinfile:
    path: "{{ nexus_install_dir }}/bin/nexus.rc"
    regexp: '^#?run_as_user=.*'
    line: "run_as_user={{ nexus_user }}"
    create: yes

- name: کپی فایل سرویس systemd از قالب
  template:
    src: nexus.service.j2
    dest: /etc/systemd/system/nexus.service
  notify: Restart Nexus

- name: فعال و راه‌اندازی Nexus
  systemd:
    name: nexus
    enabled: yes
    state: started

- name: بررسی فعال بودن Nexus (حدود ۲ دقیقه)
  uri:
    url: "http://localhost:8081"
    status_code: 200
    validate_certs: no
  register: nexus_status
  retries: 30
  delay: 10
  until: nexus_status.status == 200

- name: حذف فایل نصب Nexus از tmp
  file:
    path: "/tmp/nexus-{{ nexus_version }}.tar.gz"
    state: absent
```
handlers/main.yml
---
- name: Restart Nexus
  systemd:
    name: nexus
    state: restarted
```
templates/nexus.service.j2
```
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User={{ nexus_user }}
Group={{ nexus_group }}
ExecStart={{ nexus_install_dir }}/bin/nexus start
ExecStop={{ nexus_install_dir }}/bin/nexus stop
Restart=on-failure
TimeoutSec=600

[Install]
WantedBy=multi-user.target
```





```
---
- name: نصب و پیکربندی Nexus Repository Manager 3
  hosts: nexus_servers
  become: true

  vars:
    nexus_version: "3.68.0-04"
    nexus_user: "nexus"
    nexus_group: "nexus"
    nexus_install_dir: "/opt/nexus"
    nexus_data_dir: "/opt/sonatype-work/nexus3"
    nexus_download_url: "https://download.sonatype.com/nexus/3/nexus-{{ nexus_version }}-unix.tar.gz"

  tasks:

    # ۱. نصب Java
    - name: اطمینان از نصب Java 11
      apt:
        name: openjdk-11-jre
        state: present
        update_cache: true

    # ۲. ایجاد گروه و کاربر nexus
    - name: ایجاد گروه nexus
      group:
        name: "{{ nexus_group }}"
        state: present

    - name: ایجاد کاربر nexus
      user:
        name: "{{ nexus_user }}"
        group: "{{ nexus_group }}"
        shell: /bin/bash
        home: "{{ nexus_install_dir }}"
        create_home: no
        system: yes

    # ۳. ایجاد مسیرهای نصب و داده
    - name: اطمینان از وجود مسیرهای Nexus
      file:
        path: "{{ item }}"
        state: directory
        owner: "{{ nexus_user }}"
        group: "{{ nexus_group }}"
        mode: '0755'
      loop:
        - "{{ nexus_data_dir }}"

    # ۴. دانلود Nexus
    - name: دانلود فایل نصب Nexus
      get_url:
        url: "{{ nexus_download_url }}"
        dest: "/tmp/nexus-{{ nexus_version }}.tar.gz"
        mode: '0644'

    # ۵. استخراج فایل نصب
    - name: استخراج آرشیو Nexus
      unarchive:
        src: "/tmp/nexus-{{ nexus_version }}.tar.gz"
        dest: /opt/
        remote_src: true
        creates: "/opt/nexus-{{ nexus_version }}"

    # ۶. ساخت symlink برای مسیر ثابت
    - name: ساخت لینک نمادین برای nexus
      file:
        src: "/opt/nexus-{{ nexus_version }}"
        dest: "{{ nexus_install_dir }}"
        state: link
        force: true

    # ۷. تغییر مالکیت مسیرها
    - name: تغییر مالکیت دایرکتوری‌های Nexus
      file:
        path: "{{ item }}"
        owner: "{{ nexus_user }}"
        group: "{{ nexus_group }}"
        recurse: yes
      loop:
        - "{{ nexus_install_dir }}"
        - "{{ nexus_data_dir }}"

    # ۸. تنظیم run_as_user
    - name: تنظیم run_as_user در nexus.rc
      lineinfile:
        path: "{{ nexus_install_dir }}/bin/nexus.rc"
        regexp: '^#?run_as_user=.*'
        line: "run_as_user={{ nexus_user }}"
        create: yes

    # ۹. ایجاد سرویس systemd
    - name: ایجاد سرویس systemd برای Nexus
      copy:
        dest: /etc/systemd/system/nexus.service
        content: |
          [Unit]
          Description=Nexus Repository Manager
          After=network.target

          [Service]
          Type=forking
          LimitNOFILE=65536
          User={{ nexus_user }}
          Group={{ nexus_group }}
          ExecStart={{ nexus_install_dir }}/bin/nexus start
          ExecStop={{ nexus_install_dir }}/bin/nexus stop
          Restart=on-failure
          TimeoutSec=600

          [Install]
          WantedBy=multi-user.target
      notify: Restart Nexus

    # ۱۰. فعال‌سازی و راه‌اندازی سرویس
    - name: فعال و راه‌اندازی Nexus
      systemd:
        name: nexus
        enabled: yes
        state: started

    # ۱۱. بررسی سلامت سرویس (اختیاری ولی مفید)
    - name: بررسی فعال بودن Nexus (حدود ۲ دقیقه)
      uri:
        url: "http://localhost:8081"
        status_code: 200
        validate_certs: no
      register: nexus_status
      retries: 30
      delay: 10
      until: nexus_status.status == 200

    # ۱۲. پاک‌سازی فایل نصب
    - name: حذف فایل نصب Nexus از tmp
      file:
        path: "/tmp/nexus-{{ nexus_version }}.tar.gz"
        state: absent

  handlers:
    - name: Restart Nexus
      systemd:
        name: nexus
        state: restarted

```
