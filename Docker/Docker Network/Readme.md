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
  	  ```
	  docker run –dit --network host  ubuntu
  	  ```
* None
* Overlay
-----------------------------------------------------------------
### Port Maping 
* Port Publish (out of Host)
* Port Expose 


