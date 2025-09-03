# Simple install 

https://github.com/sonatype/docker-nexus/blob/main/docker-compose.yml
* make the volume dir in docker host
```
mkdir ./host-nexus-data
chown 200:200 ./host-nexus-data
sudo chmod -R 770 ./host-nexus-data
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
│── .env        [environment for docker-compose]
│── nginx.conf
│── upload.sh                 
│── .env.groovy [environment for upload.sh]
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
# user manual for  advance install
```
apt install unzip
```
```
wget -O Nexus.zip https://github.com/rezaabedi1365/Devops/archive/a4e2773a33c078a05d54f7fb8fb5723a0e18c6f7.zip
unzip -q Nexus.zip "Devops-a4e2773a33c078a05d54f7fb8fb5723a0e18c6f7/Nexus/*"
mv Devops-a4e2773a33c078a05d54f7fb8fb5723a0e18c6f7/Nexus ./Nexus
rm -rf Devops-a4e2773a33c078a05d54f7fb8fb5723a0e18c6f7 Nexus.zip
```
```
cd Nexus
mkdir ./host-nexus-data
sudo chown -R 200:200 ./host-nexus-data
```
step2:
  - copy your certificate in cert directory
  - change certifacates name in nginx.conf and docker-compose.yml

step3:
  - change nexus url for 80 and 443 in nginx.conf

step4:
  - change nexus url & user & pass in env.groovy

step5:
```
docker compuse up -d
```

step6:
- in nexus ui create linux-host-repo
- in nexus ui create linux-proxy-repo
- in nexus ui create linux-group-repo
- in nexus ui create docker-host-repo
- in nexus ui create docker-proxy-repo
- in nexus ui create docker-group-repo



- upload linux-repos.groovy
```
groovy_content=$(python3 -c 'import json, sys; print(json.dumps(sys.stdin.read()))' < nexus-scripts/linux-repos.groovy)

curl -u "admin:your-admin-pass" \
     --header "Content-Type: application/json" \
     -X POST \
     'http://localhost:8081/service/rest/v1/script/' \
     -d "{\"name\":\"linux-repos\",\"type\":\"groovy\",\"content\":$groovy_content}"

```

- run linux-repos.groovy
```
curl -u "admin:your-admin-pass" \
     -X POST \
     'http://localhost:8081/service/rest/v1/script/linux-repos/run'
```







--------------------------------------------------------------------
# Detail file for advance installation
--------------------------------------------------------------------

### docker compose
```
#version: "3.9"
services:
  nexus:
    image: sonatype/nexus3:latest
    container_name: nexus
    restart: unless-stopped
    ports:
      - "8081:8081"   #UI - REST API - deb&yam hosted+proxy
      - "5001:5001"   #docker-hosted
      - "5002:5002"   #docker-hub-proxy
      - "5003:5003"   #docker-group
    volumes:
      - nexus-data:/nexus-data
      - ./nexus-scripts:/opt/sonatype/nexus/etc/scripts
    environment:
      - INSTALL4J_ADD_VM_PARAMS=-Dnexus.scripts.allowCreation=true

  nginx:
    image: nginx:latest
    container_name: nexus-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./host-nexus-data:/nexus-data
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
      - ./certs/your_cert.crt:/etc/ssl/certs/your_cert.crt:ro
      - ./certs/your_chain.crt:/etc/ssl/certs/your_chain.crt:ro
      - ./certs/your_key.key:/etc/ssl/private/your_key.key:ro
    depends_on:
      - nexus


```

### nginx.conf
```
server {
    listen 80;
    server_name nexus.example.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name nexus.example.com;

    ssl_certificate     /etc/ssl/certs/your_cert.crt;
    ssl_certificate_key /etc/ssl/private/your_key.key;
    ssl_trusted_certificate /etc/ssl/certs/your_chain.crt;

    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;

    # Docker Registry (Group)
    location /v2/ {
        proxy_pass          http://nexus:5003/v2/;
        proxy_set_header    Host              $host;
        proxy_set_header    X-Real-IP         $remote_addr;
        proxy_set_header    X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto $scheme;
        proxy_buffering     off;
    }

    # Nexus UI
    location / {
        proxy_pass http://nexus:8081/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

```


### upload.sh
- Secret in .env.groovy
```
# Nexus repository credentials
NEXUS_URL=https://nexus.example.com/repository
NEXUS_USER=admin
NEXUS_PASS=your-secure-password

```
- uoload.sh
```
#!/bin/bash
set -euo pipefail

# ================================
# Load environment variables from env.groovy automatically
# ================================
ENV_FILE="env.groovy"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "❌ $ENV_FILE not found! Please create it with NEXUS_URL, NEXUS_USER, NEXUS_PASS."
    exit 1
fi

# ================================
# Validate required variables
# ================================
: "${NEXUS_URL:?Please set NEXUS_URL in $ENV_FILE}"
: "${NEXUS_USER:?Please set NEXUS_USER in $ENV_FILE}"
: "${NEXUS_PASS:?Please set NEXUS_PASS in $ENV_FILE}"

UBUNTU_REPO="ubuntu-hosted"
CENTOS_REPO="centos-hosted"
PKG_DIR="./packages"

# ================================
# Setup logging
# ================================
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/upload_$(date +%Y%m%d_%H%M%S).log"

echo "=== Starting Nexus Upload ===" | tee -a "$LOG_FILE"

# ================================
# Function to upload files
# ================================
upload_file() {
    local file=$1
    local repo=$2
    local basename=$(basename "$file")
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Uploading $basename to $repo..." | tee -a "$LOG_FILE"
    
    HTTP_CODE=$(curl -s -w "%{http_code}" -u "$NEXUS_USER:$NEXUS_PASS" --upload-file "$file" \
        "$NEXUS_URL/$repo/$basename" -o /dev/null)
    
    if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
        echo "✅ $basename uploaded successfully." | tee -a "$LOG_FILE"
    else
        echo "❌ Failed to upload $basename (HTTP $HTTP_CODE)" | tee -a "$LOG_FILE"
    fi
}

# ================================
# Upload DEB packages (Ubuntu)
# ================================
for deb in "$PKG_DIR"/*.deb; do
    [ -f "$deb" ] || continue
    upload_file "$deb" "$UBUNTU_REPO"
done

# ================================
# Upload RPM packages (CentOS)
# ================================
for rpm in "$PKG_DIR"/*.rpm; do
    [ -f "$rpm" ] || continue
    upload_file "$rpm" "$CENTOS_REPO"
done

echo "=== Nexus Upload Completed ===" | tee -a "$LOG_FILE"

```


### linux-repos.groovy
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
### docker-repos.groovy
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------


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

