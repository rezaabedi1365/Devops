```
project/
       │── html/
       │    └── index.html   (فایل اصلی سایت)
       │── nginx.conf
       └── Dockerfile
```

copy your file in html Directory
```
mkdir html
```
nginx.conf
```
# رویدادهای NGINX
events {}

# تنظیمات HTTP
http {
    # فعال کردن فشرده‌سازی gzip
    gzip on;
    gzip_types text/plain text/css application/javascript application/json image/svg+xml;

    # لاگ‌ها
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    server {
        listen 80;
        server_name _;

        # مسیر ریشه سایت
        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
        }

        # محافظت از فایل‌های مخفی (مثل .htaccess)
        location ~ /\. {
            deny all;
        }
    }
}


```
Dockerfile
```
# استفاده از ایمیج رسمی NGINX به عنوان پایه
FROM nginx:latest

# کپی کردن فایل کانفیگ سفارشی به دایرکتوری NGINX
COPY nginx.conf /etc/nginx/nginx.conf
# کپی کردن محتوای سایت (اختیاری)
COPY html/ /usr/share/nginx/html/


#WORKDIR /usr/share/nginx/html
# حالا COPY می‌تواند نسبی باشد
#COPY html/ .

# پورت مورد استفاده
EXPOSE 80

```
Build
```
docker build -t my-custom-nginx .
```
verify
```
docker image ls
```
run 
```
docker run -d -p 8080:80 my-custom-nginx
```
verify
```
docker ps
```
```
docker exec -it 131468d883de /bin/bash 
```
