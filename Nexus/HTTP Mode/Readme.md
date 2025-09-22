```
project-root/
│── docker-compose.yml
│── .env              [environment for docker-compose]
│── nginx.conf
│── gpg
    └── Private-key.asc   [generate it]
│── keys/
    ├── nexusrepo.gpg
    ├── docker.gpg
    └── kubernetes-apt-keyring.gpg
└── certs/
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
```
docker exec -it <nexus-container> curl -I http://nexus:8081/
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
      - "5001:5001" #docker-proxy
      - "5002:5002" #docker-hosted
      - "5003:5003" #quay.io proxy
    volumes:
      - ./nexus-data:/nexus-data
      - ./private-key.asc:/nexus-data/private-key.asc:ro

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
      - ./keys:/var/www/keys:ro
      - ./applications:/var/www/applications:ro
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
      - ./certs/cert.pem:/etc/ssl/certs/cert.pem:ro
      - ./certs/fullchain.pem:/etc/ssl/certs/fullchain.pem:ro
      - ./certs/private.key:/etc/ssl/private/private.key:ro
    depends_on:
      - nexus    
```

### nginx.conf
```
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name nexus.faradis.net *.nexus.faradis.net;
    return 301 https://$host$request_uri;
}

# Nexus UI + file server
server {
    listen 443 ssl;
    server_name nexus.faradis.net;

    ssl_certificate     /etc/ssl/certs/fullchain.pem;
    ssl_certificate_key /etc/ssl/private/private.key;
    ssl_trusted_certificate /etc/ssl/certs/fullchain.pem;

    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Keys path
    location /keys/ {
        root /var/www;
        autoindex on;
        try_files $uri $uri=404;
    }

    # Applications path
    location /applications/ {
        root /var/www;
        autoindex on;
        try_files $uri $uri=404;
    }

    # Nexus UI
    location / {
        proxy_pass http://nexus:8081/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect http://nexus:8081/ /;
    }
}


```


# Authorize

### insecure-registries
- in rootful
```
/etc/docker/daemon.json
```
- in rootless
```
$HOME/.config/docker/daemon.json
systemctl --user restart docker
```

```
{
  "insecure-registries" : ["nexus.faradis.net:5001", "nexus.faradis.net:5002", "nexus.faradis.net:5003"]
}
```
### docker login
```
#login to docker-hosted
docker login nexus.faradis.net:5001

#login to docker-proxy
docker login nexus.faradis.net:5002

```
- file path
```
/root/.docker/config.json
/home/<username>/.docker/config.json
```
- in rootless
```
/home/<username>/.docker/config.json
```
```
{
        "auths": {
                "https://index.docker.io/v1/": {
                        "auth": "cmV6YWFiZWRpMTM2NToxNzYxMzg0YUsxODk1bmV3"
                },
                "nexus.faradis.net:5001": {
                        "auth": "YWRtaW46LXFZSTVfQCpUJj8r"
                },
                "nexus.faradis.net:5002": {
                        "auth": "YWRtaW46LXFZSTVfQCpUJj8r"
        }
}
```

# docker pull docker-proxy
```
docker login nexus.faradis.net:5001
```

```
docker pull nexus.faradis.net:5002/nginx:latest
docker tag nginx:latest nexus.faradis.net:5002/docker-proxy/nginx:latest
docker pull library/mysql
```

# docker push and pull docker-hosted
```
docker login nexus.faradis.net:500
```
```
docker tag nginx:latest nexus.faradis.net:5001/nginx:custom1
docker tag nginx:latest nexus.faradis.net:5001/docker-hosted/nginx:custom1
```
```
docker push nexus.faradis.net:5001/nginx:custom1
docker push nexus.faradis.net:5001/docker-hosted/nginx:custom1
```
```
docker pull nexus.faradis.net:5001/nginx:custom1
```

