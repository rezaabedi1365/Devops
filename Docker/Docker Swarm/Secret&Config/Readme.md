# Secret & Config
### Config
- The Nginx container gets its configuration from Swarm, allowing all replicas to use a shared config.
```
# ایجاد nfig
docker config create nginx_conf nginx.conf

# استفاده در سرویس
docker service create \
  --name my_nginx \
  --config source=nginx_conf,target=/etc/nginx/nginx.conf \
  nginx:latest

```

### Secret
```
# ایجاد secret
echo "my_password" | docker secret create db_password -

# استفاده در سرویس
docker service create \
  --name my_db_secure \
  --secret db_password \
  mysql:5.7

```
