# Dockerfile Cheat-sheet

---

## ۱️⃣ **FROM**

تعیین می‌کنه که ایمیج پایه چی باشه. همیشه اولین دستور Dockerfile هست.

```dockerfile
FROM ubuntu:22.04
FROM ruby:2.2.2
```

---

## ۲️⃣ **MAINTAINER / LABEL**

اطلاعات درباره سازنده یا توضیحات ایمیج.

* `MAINTAINER` منسوخ شده و بهتر است از `LABEL` استفاده شود:

```dockerfile
LABEL maintainer="you@example.com"
LABEL version="1.0" description="My custom image"
```

---

## ۳️⃣ **RUN**

برای اجرای دستورات در زمان **build** استفاده می‌شود. معمولاً نصب بسته‌ها یا کانفیگ سیستم:

```dockerfile
RUN apt-get update && apt-get install -y curl
RUN gem install bundler
```

> نکته: هر `RUN` یک لایه جدید ایجاد می‌کند، بهتر است دستورات مشابه را با `&&` ترکیب کنی.

---

## ۴️⃣ **WORKDIR**

دایرکتوری کاری کانتینر را مشخص می‌کند. بعد از آن همه دستورات نسبی در همان مسیر اجرا می‌شوند.

```dockerfile
WORKDIR /myapp
```

---

## ۵️⃣ **COPY / ADD**

برای کپی کردن فایل‌ها یا دایرکتوری‌ها از میزبان به کانتینر.

```dockerfile
COPY host_file.txt /container_file.txt
ADD file.tar.gz /extract_here   # ADD می‌تواند خودکار extract کند
```

> نکته: اگر فقط کپی ساده نیاز داری، همیشه `COPY` بهتر و قابل پیش‌بینی‌تر است.

---

## ۶️⃣ **ENV**

تعریف متغیر محیطی که در زمان build و run قابل دسترسی است:

```dockerfile
ENV RAILS_ENV=production
ENV BBOX="-122.8,45.4,-122.5,45.6"
```

---

## ۷️⃣ **EXPOSE**

مستندسازی پورت‌های قابل دسترسی کانتینر:

```dockerfile
EXPOSE 3000
```

> توجه: این دستور فقط توضیح می‌دهد، برای دسترسی باید هنگام run از `-p` یا `ports` در Docker Compose استفاده کنی.

---

## ۸️⃣ **VOLUME**

تعریف volume برای داده‌های persistent:

```dockerfile
VOLUME ["/data"]
```

---

## ۹️⃣ **USER**

تعیین کاربری که دستور بعدی یا CMD با آن اجرا می‌شود:

```dockerfile
RUN groupadd -r mygroup && useradd -r -g mygroup myuser
USER myuser
```

---

## 🔟 **CMD / ENTRYPOINT**

تعیین دستور پیش‌فرض که کانتینر اجرا شود. تفاوت:

* `CMD` قابل override هنگام `docker run` است.
* `ENTRYPOINT` معمولا ثابت و غیرقابل تغییر است.

```dockerfile
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
ENTRYPOINT ["python3"]
```

---

## ۱۱️⃣ **ARG**

تعریف متغیرهایی که فقط در زمان **build** قابل استفاده هستند:

```dockerfile
ARG VERSION=1.0
RUN echo "Version is $VERSION"
```

---


```
FROM ruby:2.2.2

WORKDIR /myapp

ADD file.xyz /file.xyz
COPY --chown=user:group host_file.xyz /path/container_file.xyz

EXPOSE 5900

VOLUME ["/data"]

CMD    ["bundle", "exec", "rails", "server"]

```

