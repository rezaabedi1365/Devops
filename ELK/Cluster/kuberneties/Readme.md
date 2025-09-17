
1. Namespace `elk`
2. Elasticsearch — StatefulSet با 3 replica (headless service + PVC per pod)
3. Kibana — Deployment با replica=2 و Service
4. Logstash — Deployment با replica=2 و Service (پورت beats 5044)
5. Filebeat — DaemonSet (روی هر نود اجرا میشه، به Logstash ارسال می‌کند)
6. نکات عملی درباره تنظیمات، منابع، و نکات امنیتی

> هشدار: YAMLهای پایین **نمونه آموزشی** هستند — برای Production توصیه می‌کنم از **Elastic Cloud on Kubernetes (ECK)** یا Helm chart رسمی Elastic استفاده کنی. این YAMLها هدف «قابلیت HA پایه» را نشان می‌دهند و قبل از استفاده در محیط واقعی باید بر اساس سخت‌افزار و سیاست امنیتی شما تنظیم شوند.

---

## A — ایجاد namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: elk
```

---

## B — Headless Service برای Elasticsearch (DNS برای StatefulSet)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: elasticsearch-headless
  namespace: elk
  labels:
    app: elasticsearch
spec:
  clusterIP: None
  selector:
    app: elasticsearch
  ports:
    - port: 9200
      name: http
    - port: 9300
      name: transport
```

---

## C — StatefulSet برای Elasticsearch (3 نود)

> نکته: نیاز به storage (PVC) داره — `storageClassName` را با محیطت عوض کن.

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: elasticsearch
  namespace: elk
spec:
  serviceName: elasticsearch-headless
  replicas: 3
  selector:
    matchLabels:
      app: elasticsearch
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      containers:
        - name: elasticsearch
          image: docker.elastic.co/elasticsearch/elasticsearch:8.15.0
          env:
            - name: node.name
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: discovery.seed_hosts
              value: "elasticsearch-0.elasticsearch-headless,elasticsearch-1.elasticsearch-headless,elasticsearch-2.elasticsearch-headless"
            - name: cluster.initial_master_nodes
              value: "elasticsearch-0,elasticsearch-1,elasticsearch-2"
            - name: node.roles
              value: "master,data,ingest"
            - name: ES_JAVA_OPTS
              value: "-Xms1g -Xmx1g"
            - name: xpack.security.enabled
              value: "true"
            - name: ELASTIC_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: elastic-credentials
                  key: elastic-password
          ports:
            - containerPort: 9200
              name: http
            - containerPort: 9300
              name: transport
          resources:
            requests:
              memory: "2Gi"
              cpu: "1000m"
            limits:
              memory: "4Gi"
              cpu: "2000m"
          volumeMounts:
            - name: es-data
              mountPath: /usr/share/elasticsearch/data
      # تنظیمات امنیتی ساده:
      securityContext:
        fsGroup: 1000
  volumeClaimTemplates:
    - metadata:
        name: es-data
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: "standard"    # ← تغییر بده به StorageClass خودت
        resources:
          requests:
            storage: 20Gi
```

---

## D — Service برای Kibana & Deployment

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kibana
  namespace: elk
spec:
  selector:
    app: kibana
  ports:
    - name: http
      port: 5601
      targetPort: 5601
  type: LoadBalancer  # یا NodePort یا ClusterIP با Ingress
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kibana
  namespace: elk
spec:
  replicas: 2
  selector:
    matchLabels:
      app: kibana
  template:
    metadata:
      labels:
        app: kibana
    spec:
      containers:
        - name: kibana
          image: docker.elastic.co/kibana/kibana:8.15.0
          env:
            - name: ELASTICSEARCH_HOSTS
              value: "http://elasticsearch-0.elasticsearch-headless:9200,http://elasticsearch-1.elasticsearch-headless:9200,http://elasticsearch-2.elasticsearch-headless:9200"
            - name: ELASTICSEARCH_USERNAME
              value: "elastic"
            - name: ELASTICSEARCH_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: elastic-credentials
                  key: elastic-password
          ports:
            - containerPort: 5601
```

---

## E — Service + Deployment برای Logstash (replica 2)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: logstash
  namespace: elk
spec:
  selector:
    app: logstash
  ports:
    - name: beats
      port: 5044
      targetPort: 5044
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: logstash
  namespace: elk
spec:
  replicas: 2
  selector:
    matchLabels:
      app: logstash
  template:
    metadata:
      labels:
        app: logstash
    spec:
      containers:
        - name: logstash
          image: docker.elastic.co/logstash/logstash:8.15.0
          ports:
            - containerPort: 5044
          volumeMounts:
            - name: logstash-pipeline
              mountPath: /usr/share/logstash/pipeline/
      volumes:
        - name: logstash-pipeline
          hostPath:       # برای تست؛ در prod از ConfigMap یا PersistentVolume استفاده کن
            path: /opt/logstash/pipeline
            type: DirectoryOrCreate
```

> در عمل بهتر است `pipeline` ها را به‌صورت ConfigMap یا از یک shared storage mount کنی. همچنین از persistent queues و monitoring فعال استفاده کن.

---

## F — Filebeat DaemonSet (هر نود یک Filebeat)

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: filebeat
  namespace: elk
spec:
  selector:
    matchLabels:
      app: filebeat
  template:
    metadata:
      labels:
        app: filebeat
    spec:
      serviceAccountName: filebeat
      containers:
        - name: filebeat
          image: docker.elastic.co/beats/filebeat:8.15.0
          args: [
            "-e",
            "-c", "/etc/filebeat.yml"
          ]
          volumeMounts:
            - name: config
              mountPath: /etc/filebeat.yml
              subPath: filebeat.yml
            - name: varlog
              mountPath: /var/log
              readOnly: true
      volumes:
        - name: config
          configMap:
            name: filebeat-config
        - name: varlog
          hostPath:
            path: /var/log
            type: Directory
```

و یک `ConfigMap` برای `filebeat.yml` که خروجی را به Service `logstash:5044` می‌فرستد:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: filebeat-config
  namespace: elk
data:
  filebeat.yml: |
    filebeat.inputs:
    - type: log
      enabled: true
      paths:
        - /var/log/*.log

    output.logstash:
      hosts: ["logstash:5044"]
```

---

## G — Metricbeat DaemonSet (نمونه)

(شبیه Filebeat، اما modules و output به Logstash یا Elasticsearch می‌تونی انتخاب کنی)

```yaml
# metricbeat ConfigMap (خلاصه)
apiVersion: v1
kind: ConfigMap
metadata:
  name: metricbeat-config
  namespace: elk
data:
  metricbeat.yml: |
    metricbeat.config.modules:
      path: ${path.config}/modules.d/*.yml
      reload.enabled: false

    output.logstash:
      hosts: ["logstash:5044"]

    setup.kibana:
      host: "http://kibana:5601"
```

و یک DaemonSet مشابه Filebeat که `/proc` و `/sys/fs/cgroup` را mount می‌کند.

---

## H — Secrets (ELASTIC\_PASSWORD)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: elastic-credentials
  namespace: elk
type: Opaque
stringData:
  elastic-password: "YourStrongPassword123"
```

---

## نکات عملی و توصیه‌ها (خلاصه و ضروری)

1. حداقل 3 نود برای Elasticsearch master quorum لازم است (۳ recommended).
2. در production **از ECK (Elastic Cloud on Kubernetes)** یا رسمی Helm charts استفاده کن — خیلی از پیچیدگی‌ها را مدیریت می‌کنند (bootstrap, certs, user setup, snapshots).
3. Storage: هر نود Elasticsearch نیاز به persistent storage با IOPS مناسب دارد.
4. منابع JVM: تنظیم `ES_JAVA_OPTS` متناسب با حافظه واقعی نود بکن (Xmx ≤ 50% RAM).
5. Logstash: از `persistent queue` استفاده کن تا در صورت Down شدن داده‌ها ذخیره شوند.
6. Fronting: برای Kibana و Beats به Logstash از LoadBalancer/Ingress یا Service استفاده کن.
7. Security: TLS بین همه اجزا (شامل Beats → Logstash، Logstash → Elasticsearch) را فعال کن.
8. Backups: snapshots منظم Elasticsearch را تنظیم کن.
9. Testing: قبل از production، روی staging با شبیه‌سازی بار تست کن.

---

اگر می‌خوای من این YAMLها را به یک **single git-ready folder** تبدیل و همه ConfigMap / DaemonSet / StatefulSet کامل و آماده اجرا بسازم، یا بخوای نسخه‌ی **Helm / ECK** (توصیه‌شده) برای نصب خودکار آماده کنم بگو تا همین الآن آماده‌شون کنم.
