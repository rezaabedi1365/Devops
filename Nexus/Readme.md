
# Advance Install
```
project-root/
│── docker-compose.yml
│── .env        [environment for docker-compose]
│── nginx.conf            
├── certs/
    ├── your_cert.crt
    ├── your_chain.crt
    └── your_key.key     
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
mkdir ./nexus-data
sudo chown -R 200:200 ./nexus-data
```
step2:
  - copy your certificate in cert directory
  - change certifacates name in nginx.conf and docker-compose.yml

step3:
  - change nexus url for 80 and 443 in nginx.conf

step4:
  - change nexus url & user & pass in env.groovy

step5:
- create privatekey for hosted apt&yum repo
- this file maped in docker-compose
```
gpg --full-generate-key
```
```
docker compuse up -d
```

### verify :
```
docker compose ps
docker logs nexus
docker compose logs nexus
docker logs nexus-nginx
docker compose logs nexus-nginx
```
```
docker compose exec nexus netstat -tlnp | grep 8081
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
      - "8081:8081"   # UI - REST API - deb&yum hosted+proxy
      - "5001:5001"   # docker-hosted
      - "5002:5002"   # docker-hub-proxy
      - "5003:5003"   # docker-group
    volumes:
      - ./private-key.asc:/nexus-data/private-key.asc:ro
      - ./nexus-data:/nexus-data

    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8081"]
      interval: 30s
      timeout: 10s
      retries: 5

  nginx:
    image: nginx:latest
    container_name: nexus-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
      - ./certs/cert.pem:/etc/ssl/certs/cert.pem:ro
      - ./certs/fullchain.pem:/etc/ssl/certs/fullchain.pem:ro
      - ./certs/private.key:/etc/ssl/private/private.key:ro
    depends_on:
      - nexus    
```

### nginx.conf
```
server {
    listen 80;
    server_name nexus.faradis.net;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name nexus.faradis.net;

    ssl_certificate     /etc/ssl/certs/cert.pem;
    ssl_certificate_key /etc/ssl/private/private.key;
    ssl_trusted_certificate /etc/ssl/certs/fullchain.pem;

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

# gpg key
- generate pgp key
```
gpg --full-generate-key
```
- generate gpg key with script
```
mkdir -p ./pgp

gpg --batch --gen-key <<EOF
Key-Type: RSA
Key-Length: 4096
Name-Real: Nexus Repo Signing
Name-Email: nexus@example.com
Expire-Date: 0
%no-protection
%commit
EOF
```
- show key ID
```
gpg --list-keys nexus@example.com
```
- show private key
```
gpg --armor --export-secret-keys nexus@example.com > ./pgp/private.key
```
- Eport public key
```
gpg --armor --export nexus@example.com > ./pgp/public.key
```
### armored signature
```
gpg --armor --detach-sign -u 0123456789ABCDEF myartifact-1.0.jar
```
```
gpg --batch --yes --pinentry-mode loopback --passphrase "$GPG_PASSPHRASE" \
    --armor --detach-sign -u 0123456789ABCDEF myartifact-1.0.jar

```
