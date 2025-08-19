## Service

```
docker service create --name my-nginx -p 80:80 nginx
```
- verify :
```
docker service ls
docker service ps my-nginx
```
- scale
```
docker service scale my-nginx=3
```

