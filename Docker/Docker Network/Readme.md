# Docker Network Cheat-sheet

### Type of network Driver in Docker

* Bridge
  	- it is default and container get ip to host range (172.17.0.1 ...)
  	  ```     
	  docker run –dit ubuntu  
  	  ```
   	- you catn create newtork and assign different range ip
   	  ```
	  docker run –dit --network nework1 ubuntu  
	  ```
* Host
  	- running container exactly mapped on the host
  	-  only one instance of "host" network is allowed . by default it was created .
  	-  host is a pre-defined network and cannot be removed . you cant creat it with 
  	  ```
	  docker run –dit --network host  ubuntu
  	  ```
* None
* macvlan
* ipvaln
* Overlay
-----------------------------------------------------------------
### Port Maping 
* Port Publish (out of Host)
* Port Expose (out of Container)


------------------------------------------------------------------------
## Docker Network command

```
docker network ls
docker inspect Network_Name
docker inspect Container_Name
 ```
 	
### docker network create

Create network with spesific name but with default subnet and gateway (default driver is bridge)
```
docker network create net1
docker network create --driver bridge net1
```
Create network with spesefic name and subnet and gateway
```
docker network create   --driver=bridge   --subnet=10.10.11.0/24  --gateway=10.10.11.1   net2

```


------------------------------
```
version: "3.8"

services:
    tester:
        image: linuxserver/nginx
        environment:
            - TZ=Asia/Kuwait
        volumes:
            - ./config:/config
        ports:
            - 127.0.0.1:8081:80
        networks:
            docker_backup:
                ipv4_address: 172.18.0.3
networks:
    docker_backup:
        external: true
```




