# Simple install 

https://github.com/sonatype/docker-nexus/blob/main/docker-compose.yml
* make the volume dir in docker host
```
mkdir ./host-nexus-data
chown 200:200 ./host-nexus-data
```

```  
#version: "2"
services:
  nexus:
    image: sonatype/nexus3
    restart: always
    ports:
      - "8081:8081"
      - "8085:8085"
    volumes:
    - ./host-nexus-data:/nexus-data
 # nexus-data: {}
```

```
sudo docker-compose up -d
```
Get admin password by executing below command
```
sudo docker exec -it CONTAINER_NAME cat /nexus-data/admin.password
```
# Advance Install
```
project-root/
│── docker-compose.yml
│── nginx.conf
│── upload.sh                   # اسکریپت آپلود پکیج‌ها
│
├── certs/
│   ├── your_cert.crt
│   ├── your_chain.crt
│   └── your_key.key
│
└── nexus-scripts/
    ├── docker-repos.groovy  [Docker group repo]
    └── linux-repos.groovy   [Package group repo]
     
```

- linux-repos.groovy
  * Package group repo > hosted + proxy
```
import org.sonatype.nexus.repository.storage.WritePolicy

// === Ubuntu/Debian (APT) ===

// Hosted repo برای پکیج‌های داخلی
repository.createAptHosted(
    'ubuntu-hosted',
    WritePolicy.ALLOW
)

// Proxy repo برای mirror رسمی Ubuntu
repository.createAptProxy(
    'ubuntu-proxy',
    'http://archive.ubuntu.com/ubuntu'
)

// Group repo برای ترکیب hosted + proxy
repository.createAptGroup(
    'ubuntu-group',
    ['ubuntu-hosted', 'ubuntu-proxy']
)


// === CentOS/RedHat (YUM) ===

// Hosted repo برای پکیج‌های داخلی
repository.createYumHosted(
    'centos-hosted',
    WritePolicy.ALLOW,
    true   // deploy policy: allow redeploy
)

// Proxy repo برای mirror رسمی CentOS
repository.createYumProxy(
    'centos-proxy',
    'http://mirror.centos.org/centos/',
    true
)

// Group repo برای ترکیب hosted + proxy
repository.createYumGroup(
    'centos-group',
    ['centos-hosted', 'centos-proxy']
)

```
- docker-repos.groovy
  * Docker-group repo > hosted + proxy
```
import org.sonatype.nexus.repository.storage.WritePolicy

// ایجاد docker-hosted
repository.createDockerHosted(
    'docker-hosted', // name
    5001,            // https port
    null,            // http port
    true,            // v1 enabled?
    WritePolicy.ALLOW
)

// ایجاد docker-hub-proxy
repository.createDockerProxy(
    'docker-hub-proxy',
    'https://registry-1.docker.io',
    null,   // index type
    null,   // index url
    5002,   // https port
    null,   // http port
    true    // v1 enabled?
)

// ایجاد docker-group
repository.createDockerGroup(
    'docker-group',
    5003,          // https port
    null,          // http port
    true,          // v1 enabled?
    ['docker-hosted', 'docker-hub-proxy']
)

```
- upload.sh
  * NEXUS_URL=
  * USER=
  * PASS=
```
#!/bin/bash
set -e

# ================================
# تنظیمات Nexus
# ================================
NEXUS_URL="https://nexus.example.com/repository"
UBUNTU_REPO="ubuntu-hosted"
CENTOS_REPO="centos-hosted"
USER="admin"
PASS="your-admin-pass"

# پوشه پکیج‌ها
PKG_DIR="./packages"

# پوشه لاگ
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/upload_$(date +%Y%m%d_%H%M%S).log"

echo "=== Starting Nexus Upload ===" | tee -a "$LOG_FILE"

# ================================
# آپلود DEB ها (Ubuntu)
# ================================
for deb in "$PKG_DIR"/*.deb; do
    [ -f "$deb" ] || continue
    BASENAME=$(basename "$deb")
    echo "Uploading $BASENAME to $UBUNTU_REPO..." | tee -a "$LOG_FILE"
    RESPONSE=$(curl -s -w "%{http_code}" -u $USER:$PASS --upload-file "$deb" \
        "$NEXUS_URL/$UBUNTU_REPO/$BASENAME")
    HTTP_CODE="${RESPONSE: -3}"
    if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
        echo "✅ $BASENAME uploaded successfully." | tee -a "$LOG_FILE"
    else
        echo "❌ Failed to upload $BASENAME (HTTP $HTTP_CODE)" | tee -a "$LOG_FILE"
    fi
done

# ================================
# آپلود RPM ها (CentOS)
# ================================
for rpm in "$PKG_DIR"/*.rpm; do
    [ -f "$rpm" ] || continue
    BASENAME=$(basename "$rpm")
    echo "Uploading $BASENAME to $CENTOS_REPO..." | tee -a "$LOG_FILE"
    RESPONSE=$(curl -s -w "%{http_code}" -u $USER:$PASS --upload-file "$rpm" \
        "$NEXUS_URL/$CENTOS_REPO/$BASENAME")
    HTTP_CODE="${RESPONSE: -3}"
    if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
        echo "✅ $BASENAME uploaded successfully." | tee -a "$LOG_FILE"
    else
        echo "❌ Failed to upload $BASENAME (HTTP $HTTP_CODE)" | tee -a "$LOG_FILE"
    fi
done

echo "=== Nexus Upload Completed ===" | tee -a "$LOG_FILE"

```
```
chmod +x upload.sh
./upload.sh
```

# Package Repo
### Upload Package in host repo
##### YUM repo
```
curl -u admin:your-pass \
     --upload-file eset_nod32av-4.0.85.rpm \
     https://nexus.example.com/repository/centos-hosted/eset_nod32av-4.0.85.rpm
```
- add package repo in client
```
cat <<EOF | sudo tee /etc/yum.repos.d/nexus.repo
[nexus]
name=Nexus YUM Repository
baseurl=https://nexus.example.com/repository/centos-hosted/
enabled=1
gpgcheck=0
EOF
```
```
sudo yum clean all
sudo yum install eset_nod32av
```
##### Debian repo
```
curl -u admin:your-pass \
     --upload-file splunkforwarder-9.0.5.deb \
     https://nexus.example.com/repository/ubuntu-hosted/splunkforwarder-9.0.5.deb
```
- add package repo in client
```
echo "deb [trusted=yes] https://nexus.example.com/repository/ubuntu-hosted/ jammy main" | sudo tee /etc/apt/sources.list.d/nexus.list
```
```
sudo apt update
sudo apt install splunkforwarder
```
# Docker Repo
- upload Docker image in nexus Docker repo
```
docker login nexus.example.com
docker tag my-app:latest nexus.example.com/my-project/my-app:1.0
docker push nexus.example.com/my-project/my-app:1.0
```

