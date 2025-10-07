nginx/Dockerfile
```
FROM nginx:alpine

# ایجاد کاربر غیر روت (مثلاً uid=1001)
RUN addgroup -S nginxgroup && adduser -S nginxuser -G nginxgroup

# تغییر مالکیت فایل‌ها به کاربر جدید
RUN chown -R nginxuser:nginxgroup /var/cache/nginx /var/run /var/log/nginx /etc/nginx /usr/share/nginx/html

# سوئیچ به کاربر غیر روت
USER nginxuser

# اجرای nginx
CMD ["nginx", "-g", "daemon off;"]

```

nginx/default.conf
```
server {
    listen 80;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```
```
docker compose up --build
```
