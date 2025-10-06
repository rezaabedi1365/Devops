```
ansible-project/
├── inventory/
│   ├── production.ini         ← سرورهای محیط عملیاتی
│   ├── staging.ini            ← سرورهای محیط تست
│   └── local.ini              ← سرور محلی یا ماشین توسعه
│
├── playbooks/
│   ├── nexus.yml              ← نصب و پیکربندی Nexus
│   ├── docker.yml             ← نصب Docker
│   ├── kubernetes.yml         ← نصب K8s (master + node)
│   ├── gitlab.yml             ← نصب GitLab
│   ├── gitlab-runner.yml      ← نصب GitLab Runner
│   ├── prometheus.yml         ← نصب Prometheus
│   ├── zabbix.yml             ← نصب Zabbix
│   ├── elk.yml                ← نصب ELK Stack (Elasticsearch + Logstash + Kibana)
│   └── site.yml               ← اجرای همه نقش‌ها با هم (کل زیرساخت)
│
├── group_vars/
│   ├── all.yml                ← متغیرهای عمومی (مثل timezone، proxy، user)
│   ├── docker.yml             ← متغیرهای اختصاصی Docker
│   ├── kubernetes.yml         ← متغیرهای اختصاصی K8s
│   ├── gitlab.yml             ← متغیرهای GitLab
│   ├── monitoring.yml         ← متغیرهای Prometheus/Zabbix
│   └── logging.yml            ← متغیرهای ELK
│
├── roles/
│   ├── docker/
│   │   ├── tasks/
│   │   ├── handlers/
│   │   ├── templates/
│   │   ├── vars/
│   │   └── README.md
│   ├── kubernetes/
│   │   ├── tasks/
│   │   ├── templates/
│   │   └── vars/
│   ├── gitlab/
│   │   ├── tasks/
│   │   └── templates/
│   ├── gitlab-runner/
│   │   ├── tasks/
│   │   └── vars/
│   ├── nexus/
│   │   ├── tasks/
│   │   ├── templates/
│   │   └── vars/
│   ├── prometheus/
│   │   ├── tasks/
│   │   ├── templates/
│   │   └── vars/
│   ├── zabbix/
│   │   ├── tasks/
│   │   ├── templates/
│   │   └── vars/
│   └── elk/
│       ├── tasks/
│       ├── templates/
│       └── vars/
│
├── files/                     ← فایل‌های استاتیک (مثل scriptها، configها)
│   ├── ssl/
│   └── custom-configs/
│
├── ansible.cfg                ← تنظیمات انسیبل (مسیر role، timeout، privilege escalation)
└── README.md                  ← مستندات پروژه

```
