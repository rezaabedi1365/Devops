
nginx.conf
```
events {}

http {
    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
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
