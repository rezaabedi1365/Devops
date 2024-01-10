![image](https://github.com/rezaabedi1365/Devops/assets/117336743/440e69c6-d14d-4232-9bbd-aa35f64fbdd4)


# Docker volume Cheat-sheet

### Type of Volume in Docker

* volume
  	- /var/lib/docker/volume
  	- volumes use regulary
  	- share between containers is simple
      ```     
      docker run -d -v [VOLUME]:/var/www/html/    nginx 
      ```
* Bind Mount
  	- Bind mount use for config file mostly
  	- other proccess outside container can be change data

      ```
      cd /root/containers/nginx
      docker run -d -v  ./mydir:/var/www/html/    nginx 
      docker run -d -v  ${PWD}/mydir:/var/www/html/    nginx 
  	  ```
* tempfs
    - store data in RAM 
      ```
      docker run –dit --mount type=tmpfs,dst=/var/www/html/ nginx

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
