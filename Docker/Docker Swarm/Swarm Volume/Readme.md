## Volume
<img width="739" height="213" alt="image" src="https://github.com/user-attachments/assets/78d113dc-5291-4e2c-8c18-513071000361" />


- local (Dafault)
- bind
- tmpfs
- Extra (NFS)

### local (Default)
```
docker volume create my_local_data

docker service create \
  --name db_local \
  --mount type=volume,source=my_local_data,target=/var/lib/mysql \
  mysql:5.7

```
### bind 
- mount path from host to container
```
docker service create \
  --name web_bind \
  --mount type=bind,source= . ,target=/usr/share/nginx/html \
  nginx:alpine

```

### tmpfs
```
docker service create \
  --name cache_service \
  --mount type=tmpfs,target=/cache \
  nginx:alpine

```

### Extra (NFS)
```
docker volume create \
  --driver local \
  --opt type=nfs \
  --opt o=addr=192.168.1.100,rw \
  --opt device=:/export/data \
  my_nfs_data

docker service create \
  --name db_nfs \
  --mount type=volume,source=my_nfs_data,target=/var/lib/mysql \
  mysql:5.7
```
