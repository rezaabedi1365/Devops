# Docker Network Cheat-sheet

### Type of network Driver in Docker

* Bridge
  	- default Network_Name wich built in is bridg with bridge driver(172.17.0.0/16 With bridge driver and bridge Network_Name)
  	  ```     
	  docker run –dit ubuntu  
  	  ```
   	- you catn create bridge newtork with specefic name and assign different range ip
   	  ```
   	  docker network create   --driver=bridge   --subnet=10.10.11.0/24  --gateway=10.10.11.1   net2
	  docker run –dit --network net2 --ip 10.10.11.10 ubuntu  
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
------------------------------------------------------------------------
## Docker Network command

```
docker network ls
docker inspect Network_Name
docker inspect Container_Name
```
```
docker inspect Network_Name | grep IPv4Address
docker exec [container-id or container-name] cat /etc/hosts 	
docker exec [container-id or container-name] cat /etc/hostname

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
subneting :
```
docker network create   --driver=bridge   --subnet=10.10.11.0/25  --gateway=10.10.11.1   net3
docker network create   --driver=bridge   --subnet=10.10.11.128/25  --gateway=10.10.11.129   net4
```
### docker network rm
```
docker network rm Network_Name
docker network rm Network_ID
```
Reomove all unused Networks
```
docker network prune
```
### docker network connect / disconnect
```
docker network connect net4 Container_Name
docker network disconnect net4 Container_Name
```



### docker run
```
docker run -dit --name nginx1  --network net1  nginx:latest
docker run -dit --name nginx1  --network none  nginx:latest
```
user specified IP address is supported only when connecting to networks with user configured subnets.
geteway was set whten network configured
```
docker run -dit --name nginx1 --network net1 --ip 10.10.12.20 nginx:latest
```

### route
```
ip route
route
```

-----------------------------------------------------------------
### Port Maping 

* Port Expose (out of Container) --expose
	- Docker Compose sets up a dedicated network for the defined containers, enabling communication between them
	- ports will be accessible by other services connected to the same network, but won’t be published on the host machine.
	- syntax
	```
	myapp1:
          expose:
            - "3000"
            - "8000"
 	 myapp2:
           expose:
            - "5000"
	 ```

* Port Publish (out of Host) -p
	- bind for 0.0.0.0:80 failed: port is already allocated.
 	- these ports will be accessible internally and published on the host machine.
	- syntax
	```
     ports:
       - "3000"                        # container port (3000), assigned to random host port
       - "3001-3005"                   # container port range (3001-3005), assigned to random host ports
       - "8000:8000"                   # container port (8000), assigned to given host port (8000)
       - "9090-9091:8080-8081"         # container port range (8080-8081), assigned to given host port range (9090-9091)
       - "127.0.0.1:8002:8002"         # container port (8002), assigned to given host port (8002) and bind to 127.0.0.1
       - "6060:6060/udp"               # container port (6060) restricted to UDP protocol, assigned to 
 	
 	```



-----------------------------------------------------------------
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




