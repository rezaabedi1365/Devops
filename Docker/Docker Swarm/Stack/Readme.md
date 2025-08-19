
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

