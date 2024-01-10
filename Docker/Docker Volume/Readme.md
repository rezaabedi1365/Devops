![image](https://github.com/rezaabedi1365/Devops/assets/117336743/440e69c6-d14d-4232-9bbd-aa35f64fbdd4)


# Docker volume Cheat-sheet

### Type of Volume in Docker

* volume
  	- /var/lib/docker/volume
  	- volumes use regulary
  	- share between containers is simple
      ```     
      docker run -d -v Volume_Name:/var/www/html/    nginx 
      ```
  	  ```
  	   docker run --mount type=volume،source=Volume_Name،destination=/var/www/html،readonly
       ```
* Bind Mount
  	- Bind mount use for config file mostly
  	- other proccess outside container can be change data

      ```
      cd /root/containers/nginx
      docker run -d -v  ./mydir:/var/www/html/    nginx 
      docker run -d -v  ${PWD}/mydir:/var/www/html/    nginx 
  	  ```
  	  ```
  	  docker run --mount type=volume،source=./mydir،destination=/var/www/html،readonly 
      ```

* tempfs
    - store data in RAM 
      ```
      docker run –dit --mount type=tmpfs,dst=/var/www/html/ nginx
      ```
      ```
      docker run –d --mount type=tmpfs,dst=/var/www/html/ nginx
      ```

------------------------------------------------------------------------
## Volume assign
* --volume
* --mount
    ```
    key=
    type=
    source=
    destination=
    readnonly
    ```

   --------------------------------------------------------------------------
## Docker volume command
show docker volume
```
docker volume ls
docker volume inpect
```
* docker volume create
defualt driver is local 
```
docker volume create myvol1
docker volume create --driver local myvol1
docker volume create --driver local --opt type=btrfs --opt device=dev/sda --opt o=size=500m,uid=100 myvol1
```
![image](https://github.com/rezaabedi1365/Devops/assets/117336743/d4bd8370-a1b3-4b32-bd89-7d50dfcfa5d0)

```  
docker volume create --driver flocker -o size=20GB my-named-volume
docker volume create --driver local --opt type=tmpfs --opt device=tmpfs --opt o=size=100m,uid=1000
docker volume create --driver local --opt type=btrfs --opt device=/dev/sda2
docker volume create --driver local --opt type=tmpfs --opt device=tmpfs --opt o=size=100m,uid=1000 foo
docker volume create --driver convoy --opt size=100m test
```
* docker volume rm
  ```
  docker volume rm Volume_Name
  ```
-------------------------------------------------------------------------------------
You can use an externally created volume in Docker Compose by specifying the volume and setting its value of external to true
 ```
services:
  frontend:
    image: node:lts
    volumes:
      - myapp:/home/node/app
volumes:
  myapp:
    external: true
 ```
