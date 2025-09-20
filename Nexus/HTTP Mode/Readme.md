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

### Client Config
- in rootful
```
/etc/docker/daemon.json
```
- in rootless
```
$HOME/.config/docker/daemon.json
```
```
{
  "insecure-registries" : ["nexus.faradis.net:5001", "nexus.faradis.net:5002", "nexus.faradis.net:5003"]
}
```


### login authrize 
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

### docker pull docker-proxy
```
docker login nexus.faradis.net:5001
```

```
docker pull nexus.faradis.net:5002/nginx:latest
docker tag nginx:latest nexus.faradis.net:5002/docker-proxy/nginx:latest
docker pull library/mysql
```

### docker push and pull docker-hosted
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

