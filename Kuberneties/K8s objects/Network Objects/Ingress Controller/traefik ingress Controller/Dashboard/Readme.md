خیلی عالی 🚀
داشبورد **Traefik** یکی از بهترین ابزارها برای **مانیتور کردن Routeها، سرویس‌ها و وضعیت ترافیک**ه.
بذار مرحله‌به‌مرحله توضیح بدم چطور فعال و تستش کنی:

---

## 🔹 ۱. فعال کردن API و Dashboard

Traefik به صورت پیش‌فرض داشبورد رو می‌سازه ولی **غیرفعاله**. برای فعال کردن باید توی کانفیگش فلگ‌ها رو اضافه کنی:

اگر Traefik رو با **Helm** نصب کردی (معمول‌ترین روش):

تو `values.yaml` مقدار زیر رو بذار:

```yaml
additionalArguments:
  - "--api.insecure=true"
  - "--api.dashboard=true"
```

یا اگر مستقیم با Deployment نصب کردی، توی قسمت `args` این دو خط رو اضافه کن:

```yaml
args:
  - "--api.insecure=true"
  - "--api.dashboard=true"
```

---

## 🔹 ۲. بررسی سرویس داشبورد

وقتی فلگ `--api.insecure=true` فعال باشه، داشبورد به صورت پیش‌فرض روی **پورت 8080** بالا میاد.

با این دستور ببین سرویسش هست یا نه:

```bash
kubectl get svc -n traefik
```

باید چیزی مثل این ببینی:

```
traefik-dashboard   ClusterIP   10.x.x.x   <none>   8080/TCP
```

---

## 🔹 ۳. دسترسی به داشبورد

راه‌های دسترسی:

### 🟢 راه ساده (port-forward)

```bash
kubectl port-forward -n traefik deploy/traefik 8080:8080
```

بعدش تو مرورگر بزن:

```
http://localhost:8080/dashboard/
```

---

### 🟢 راه اصولی (IngressRoute)

اگر می‌خوای داشبورد از بیرون هم در دسترس باشه، می‌تونی یه **IngressRoute** تعریف کنی:

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard
  namespace: traefik
spec:
  entryPoints:
    - web
  routes:
    - match: Host(`traefik.local`)
      kind: Rule
      services:
        - name: api@internal
          kind: TraefikService
```

حالا اگر توی `/etc/hosts` بنویسی:

```
<NODE-IP>   traefik.local
```

می‌تونی داشبورد رو تو مرورگر ببینی:

```
http://traefik.local/dashboard/
```

---

## 🔹 ۴. نکته امنیتی خیلی مهم ⚠️

فلگ `--api.insecure=true` بدون پسورد همه‌چیز رو در معرض عموم می‌ذاره!
برای محیط **Production** توصیه میشه:

* از `--api.insecure=false` استفاده کنی.
* و دسترسی رو با **BasicAuth Middleware** یا **TLS** محدود کنی.

---

✅ جمع‌بندی:

* `--api.insecure=true` و `--api.dashboard=true` → فعال کردن داشبورد.
* دسترسی: `kubectl port-forward` یا تعریف یک `IngressRoute`.
* امنیت: حتماً روی محیط واقعی با پسورد یا TLS امن کن.

---

می‌خوای برات یه **IngressRoute امن با BasicAuth** هم بنویسم که داشبوردت رمز داشته باشه؟


-------------------------------------------------------------------------
عالیه 👌
پس بریم یه **IngressRoute امن با BasicAuth** برای داشبورد Traefik بسازیم.

---

## 🔹 ۱. ساختن یوزر و پسورد با htpasswd

اول باید یه یوزر/پسورد درست کنیم (مثلاً: `admin:1234`)

روی سیستم خودت اجرا کن:

```bash
sudo apt-get install apache2-utils   # اگر نداری
htpasswd -nb admin 1234
```

خروجی چیزی مثل این میشه:

```
admin:$apr1$z2k5...$2sQ8b4LtGkXKm8kZpYpUq.
```

---

## 🔹 ۲. ساخت Secret در Kubernetes

حالا خروجی بالا رو توی یک Secret بذار:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: traefik-dashboard-auth
  namespace: traefik
data:
  users: YWRtaW46JGFwcjEk...   # این همون htpasswd انکود شده base64 است
```

👉 نکته: اگر `htpasswd` خروجی ساده داد، باید با دستور زیر base64 انکودش کنی:

```bash
echo 'admin:$apr1$z2k5...$2sQ8b4LtGkXKm8kZpYpUq.' | base64
```

---

## 🔹 ۳. تعریف Middleware برای BasicAuth

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: dashboard-auth
  namespace: traefik
spec:
  basicAuth:
    secret: traefik-dashboard-auth
    realm: "Traefik Dashboard"
```

---

## 🔹 ۴. ساخت IngressRoute امن

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard
  namespace: traefik
spec:
  entryPoints:
    - web
  routes:
    - match: Host(`traefik.local`)
      kind: Rule
      services:
        - name: api@internal
          kind: TraefikService
      middlewares:
        - name: dashboard-auth
```

---

## 🔹 ۵. دسترسی به داشبورد

حالا اگه تو `/etc/hosts` بنویسی:

```
<NODE-IP>   traefik.local
```

و بعد تو مرورگر بزنی:

```
http://traefik.local/dashboard/
```

یک پنجره Login باز میشه → یوزر/پسوردی که ساختی (`admin:1234`) رو وارد کن. ✅

---

📌 اینطوری داشبورد Traefik فقط با یوزر و پسورد قابل دسترس خواهد بود.

می‌خوای من همین Secret + Middleware + IngressRoute رو به صورت یک **مانیفست یکجا (all-in-one)** برات آماده کنم که مستقیم apply کنی؟


---------------------------------------------
خیلی خب 👌 اینجا یه **مانیفست یکجا (all-in-one)** می‌ذارم که شامل سه بخشه:

1. **Secret** برای ذخیره‌ی یوزر/پسورد (`admin:1234`)
2. **Middleware** برای BasicAuth
3. **IngressRoute** برای دسترسی امن به داشبورد Traefik

---

```yaml
# =========================
# 1. Secret برای BasicAuth
# =========================
apiVersion: v1
kind: Secret
metadata:
  name: traefik-dashboard-auth
  namespace: traefik
type: Opaque
data:
  # admin:1234
  users: YWRtaW46JGFwcjEkV2dvZy4uLi5nTVlqc2lyNE5sdHZ4QklyZlQyMw==
---
# =========================
# 2. Middleware برای Auth
# =========================
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: dashboard-auth
  namespace: traefik
spec:
  basicAuth:
    secret: traefik-dashboard-auth
    realm: "Traefik Dashboard"
---
# =========================
# 3. IngressRoute برای داشبورد
# =========================
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard
  namespace: traefik
spec:
  entryPoints:
    - web
  routes:
    - match: Host(`traefik.local`)
      kind: Rule
      services:
        - name: api@internal
          kind: TraefikService
      middlewares:
        - name: dashboard-auth
```

---

### 🔹 نحوه استفاده:

1. رمز `admin:1234` رو من برای تست گذاشتم.
   اگه می‌خوای یوزر/پسورد دیگه بزنی:

   ```bash
   htpasswd -nb admin 1234 | base64
   ```

   و خروجی رو جایگزین قسمت `users:` کن.

2. فایل رو ذخیره کن (مثلاً `traefik-dashboard-secure.yaml`) و Apply کن:

   ```bash
   kubectl apply -f traefik-dashboard-secure.yaml
   ```

3. توی `/etc/hosts` اضافه کن:

   ```
   <NODE-IP>   traefik.local
   ```

4. بعدش تو مرورگر برو به:

   ```
   http://traefik.local/dashboard/
   ```

   یوزر و پسورد رو وارد کن → ✅ وارد داشبورد می‌شی.

---

می‌خوای همینو یه نسخه‌ی **HTTPS (با TLS)** هم برات بسازم که داشبورد فقط روی `https://` در دسترس باشه؟

