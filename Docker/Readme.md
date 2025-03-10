
### Docker exec ( entire in bash or consol from Container) 
* -it  
```
docker exec -it containername /bin/bash
docker exec -it containername powershell
```
### docker cp
```
# copy file from container to host
docker cp <container>:/path/to/file.ext .

# copy file from hot to container 
docker cp file.ext <container>:/path/to/file.ext
```
* Edit Files in the volume
* Any changes to files inside the mounted volume are reflected on both the host machine and the container. Edit files in the mounted volume using the steps mentioned earlier.
### docker Import /export  (for container) 
```
```
### docker update 
```
```
###   Docker ps –a 
```
```
### Docker stats     (show resource usage each containers ) 
```
```
### Docker event 
```
docker event    - -until 10m 
```

### docker logs
```
docker logs --tail 50 --follow --timestamps CONTAINER_NAME
```

### Docker port 
```
```
### Docker diff 
```
```
### Docker inspect nginx1  (show detail for image) 
```
```
### Docker top nginx 
```
```
### Docker stop / start 
```
```
### Docker restart    (we cant restart service, instead because we have one service each container we restart container ) 
```
```
### Docker kill 
```
```
### Docker rm 
```
```
### Docker attach 
```
```

