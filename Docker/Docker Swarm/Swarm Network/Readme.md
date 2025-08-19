
- ingress
- overlay

## overlay
- just releation between container and not published 
- sample : docker network between app and api container
```
# ایجاد شبکه overlay
docker network create -d overlay my_overlay

# ایجاد سرویس app و اتصال به شبکه
docker service create --name app --network my_overlay nginx:alpine

# ایجاد سرویس api و اتصال به همان شبکه
docker service create --name api --network my_overlay nginx:alpine

```

# ingress
- created by default with swarm just publish port with an
```
# ایجاد یک سرویس وب که روی پورت 80 در دسترس باشد
docker service create \
  --name web_service \
  --publish published=80,target=80 \
  nginx:alpine

```
