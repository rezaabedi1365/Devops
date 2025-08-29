خیلی خوب، حالا می‌خوای علاوه بر Traefik (لایه ۴) یک **HAProxy خارجی** هم داشته باشی که به عنوان **Reverse Proxy لایه ۷ (HTTP/HTTPS)** عمل کند و درخواست‌های وب را بین Podهای Nginx توزیع کند.

این یعنی معماری نهایی:

```
[Client] → [HAProxy (L7)] → [Traefik (L4)] → [Nginx Deployment]
```

---

### 📌 نمونه پیکربندی HAProxy برای Kubernetes

فرض می‌کنیم HAProxy خارج از کلاستر اجرا می‌شود و آدرس NodePort Traefik (یا LoadBalancer) را به عنوان backend دارد.

```cfg
# haproxy.cfg
global
    log stdout format raw local0
    maxconn 4096
    tune.ssl.default-dh-param 2048

defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5s
    timeout client  50s
    timeout server  50s
    retries 3

frontend http_front
    bind *:80
    mode http
    default_backend web_back

frontend https_front
    bind *:443 ssl crt /etc/haproxy/certs/yourcert.pem
    mode http
    default_backend web_back

backend web_back
    mode http
    balance roundrobin
    option http-server-close
    option forwardfor

    # لیست NodePort یا LoadBalancer های Traefik
    server web1 <NodeIP1>:30008 check
    server web2 <NodeIP2>:30008 check
    server web3 <NodeIP3>:30008 check
```

---

### 🔹 توضیح

1. **Frontend**

   * `http_front` → پورت 80، همه درخواست‌های HTTP را می‌گیرد.
   * `https_front` → پورت 443، TLS termination با گواهی SSL.
2. **Backend**

   * `web_back` → Pool از NodePortهای Traefik که Nginx Deployment را سرو می‌کنند.
   * Load Balancing با **round-robin**.
   * HAProxy ترافیک لایه ۷ را مدیریت می‌کند (HTTP headers, cookies, SSL termination).
3. با این روش:

   * Client → HAProxy (L7) → Traefik (L4) → Nginx Podها
   * امکان **SSL termination و HTTP routing پیشرفته** با HAProxy وجود دارد.
   * Traefik فقط TCP proxy می‌کند و Load Balancing Layer 4 انجام می‌دهد.

---

اگر بخواهی، می‌توانم یک **YAML کامل Kubernetes برای HAProxy داخل کلاستر** هم آماده کنم که:

* به صورت **Deployment + Service** باشد
* به NodePort یا Traefik route وصل شود
* به عنوان **Reverse Proxy لایه ۷ داخلی کلاستر** عمل کند

می‌خوای برات این نسخه داخل کلاستر هم آماده کنم؟
