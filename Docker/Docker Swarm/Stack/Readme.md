## Stack
```
nano nginx-stack.yml
```
```
version: "3.8"

services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    deploy:
      replicas: 3        # تعداد replicaها
      restart_policy:
        condition: on-failure
      placement:
        constraints:
          - node.role == worker   # فقط روی workerها اجرا بشه (اختیاری)
```

```
docker stack deploy -c nginx-stack.yml my_stack
```

- verify:
```
docker stack ls                  # لیست stackها
docker stack services my_stack   # لیست سرویس‌های داخل stack
docker stack ps my_stack         # taskها (کانتینرهای اجراشده)
```

- stack with storage
```
version: "3.8"

services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - nginx_data:/usr/share/nginx/html:ro   # محتوای سفارشی وب
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
      update_config:
        parallelism: 1
        delay: 10s
      placement:
        constraints:
          - node.role == worker

volumes:
  nginx_data:

```
```
docker stack deploy -c nginx-stack.yml my_stack
```

# Senario
- create nginx reverse proxy
```
nano nginx-stack.yml
```
```
version: "3.8"

services:
  reverse-proxy:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro   # فایل کانفیگ Nginx سفارشی
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == manager   # فقط روی manager اجرا بشه (اختیاری)

  app:
    image: nginx:alpine
    deploy:
      replicas: 2
    networks:
      - backend

  api:
    image: nginx:alpine
    deploy:
      replicas: 2
    networks:
      - backend

networks:
  backend:
    driver: overlay
```
```
nano nginx.conf
```
```
events {}

http {
    upstream app_cluster {
        server app:80;
    }

    upstream api_cluster {
        server api:80;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://app_cluster;
        }

        location /api/ {
            proxy_pass http://api_cluster;
        }
    }
}
```
```
docker stack deploy -c docker-compose.yml my_stack
```

- http://<IP>/api
- http://<IP>/app
