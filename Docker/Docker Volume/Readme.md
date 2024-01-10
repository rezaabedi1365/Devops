![image](https://github.com/rezaabedi1365/Devops/assets/117336743/26a3b578-3507-4c7e-ad6e-f085e9235b7b)![image](https://github.com/rezaabedi1365/Devops/assets/117336743/73fcf083-b10e-46e9-98ab-58f7ef3956bf)
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
		  docker run -d -v   ./mydir:/var/www/html/    nginx 
      docker run -d -v   ${PWD}/mydir:/var/www/html/    nginx 
  	  ```
* tempfs
    - store data in RAM 
      ```
      docker run –dit --mount type=tmpfs,dst=/var/www/html/ nginx

      ```

------------------------------------------------------------------------
## Docker Network command
