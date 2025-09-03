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
