
```
docker swarm init
```
<img width="1046" height="120" alt="image" src="https://github.com/user-attachments/assets/fd4ce605-a9f4-4874-b3f8-1ee1d020d689" />

```                                                                                                                                                                                                                        
docker swarm join-token worker      # نمایش دستور join مخصوص worker

docker swarm join-token manager     # نمایش دستور join مخصوص manager
```
## verify:
- Cluster & Node
```
docker info
docker node ls
docker node inspect <NODE-ID>  #jason
docker node inspect <NODE-ID> --pretty   #human readable
```

- Service
```
docker service ls
docker service ps <SERVICE>
docker service inspect <SERVICE>
docker service scale <SERVICE>=<NUM>
```

- Tasks & Containers
```
docker ps
docker stack ps <STACK>
docker stack services <STACK>
```

- Stack (Multi-service Apps)
```
docker stack deploy -c <compose-file> <STACK>
docker stack ls
docker stack rm <STACK>
```


