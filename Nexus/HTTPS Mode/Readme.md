

# Advance Install
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
      - ./keys:/var/www/keys:ro
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

    ssl_certificate     /etc/ssl/certs/fullchain.pem;
    ssl_certificate_key /etc/ssl/private/private.key;
    ssl_trusted_certificate /etc/ssl/certs/fullchain.pem;

    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;


    # keys path
    location /keys/ {
        root /var/www;
       #alias /var/www/keys/;
        autoindex on;
        try_files $uri $uri=404;
    }

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


# APT Repo
- Change sources.list in ubuntu
```
cp /etc/apt/sources.list /etc/apt/sources.list_bk
sudo sed -i 's|http://ir.archive.ubuntu.com/ubuntu/|https://nexus.faradis.net/repository/apt-proxy/|g' /etc/apt/sources.list
sudo sed -i 's|http://archive.ubuntu.com/ubuntu/|https://nexus.faradis.net/repository/apt-proxy/|g' /etc/apt/sources.list
sudo sed -i 's|http://security.ubuntu.com/ubuntu/|https://nexus.faradis.net/repository/apt-proxy/|g' /etc/apt/sources.list
```
- if use selfcertificate copy public and root and intermediate
```
sudo cp /path/to/root.crt /usr/local/share/ca-certificates/
sudo cp /path/to/intermediate.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```
```
sudo cp /path/to/root.crt /etc/ssl/certs
sudo cp /path/to/intermediate.crt /etc/ssl/certs
sudo update-ca-certificates
```
- check cert in client

```
openssl s_client -connect nexus.faradis.net:443 -CApath /etc/ssl/certs
```
- check cert chain
```
openssl s_client -connect nexus.faradis.net:443 -showcerts
```
### Upload Package to apt-hosted
Method1) with curl
```
curl -v -u <username>:<password> \
  --upload-file mypackage_1.0.0_amd64.deb \
  http://<nexus-host>:<port>/repository/apt-hosted/pool/m/mypackage/mypackage_1.0.0_amd64.deb

```
Method2) with dput
- /etc/dput.cf
```
[nexus]
fqdn = nexus.faradis.net:8081
method = http
login = <username>
pass = <password>
incoming = /repository/apt-hosted
```



# docker repo 
- create role(docker role) with nx-repo administrator > Create user with (docekr role) group
- Change realm
<img width="1066" height="658" alt="image" src="https://github.com/user-attachments/assets/0929fb28-9729-4853-bc25-dbf4282ab831" />

- in client
```
docker login nexus.faradis.net:5001
docker login nexus.faradis.net:5002
```
```
dput nexus mypackage_1.0.0_source.changes
```

### docker.list
#### Method1 : without gpg
- docker-apt-proxy
```
cp /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/docker.list_bk
echo "deb [trusted=yes] https://nexus.faradis.net/repository/docker-apt-proxy/ jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

- sudo nano /etc/apt/sources.list.d/docker.list
- deb [trusted=yes] https://nexus.faradis.net/repository/docker-apt-proxy/ jammy stable

##### Method2: with gpg
- downloads gpg
```
sudo curl -fsSL https://nexus.faradis.net/keys/docker.asc -o /etc/apt/keyrings/docker.asc
```
```
sudo curl -k -fsSL https://nexus.faradis.net/keys/docker.asc -o /etc/apt/keyrings/docker.asc
```
- deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://nexus.faradis.net/repository/docker-apt-proxy/ jammy stable
```
sudo sed -i 's|https://download.docker.com/linux/ubuntu|https://nexus.faradis.net/repository/docker-apt-proxy/|' /etc/apt/sources.list.d/docker.list
```
### Docker Repo with Self-signed Certificate
- in rootles
```
mkdir -p ~/.local/share/docker/certs.d/nexus.faradis.net/
cp fullchain.pem ~/.local/share/docker/certs.d/nexus.faradis.net/ca.crt
```
- system-wide Docker (root user)
```
mkdir -p /etc/docker/certs.d/nexus.faradis.net/
cp fullchain.pem /etc/docker/certs.d/nexus.faradis.net/ca.crt
```
```
systemctl --user restart docker
```
- verify
```
openssl s_client -connect nexus.faradis.net:443 -CAfile ~/.local/share/docker/certs.d/nexus.faradis.net/ca.crt
```

