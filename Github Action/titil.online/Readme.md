```
GithubRepo-title_project/
│── Dockerfile                # فایل Dockerfile برای ساخت ایمیج
│── docker-compose.yml        # فایل docker-compose برای اجرای سرویس‌ها (اختیاری)
│── requirements.txt          # لیست کتابخونه‌های پایتون
│── address_book.py           # کد اصلی Flask
│── README.md                 # توضیحات پروژه
│
└── .github/
    └── workflows/
        └── deploy.yml        # فایل GitHub Actions Build & Push to docker hub
```
<img width="1433" height="730" alt="image" src="https://github.com/user-attachments/assets/184845e6-f877-4f47-b85f-d67932700f27" />

### requirements.txt
```
Flask==3.0.3
Flask-SQLAlchemy==3.1.1
pytest==8.3.2
gunicorn==22.0.0
```
### Dockerfile
```
# استفاده از نسخه سبک پایتون
FROM python:3.11-slim

# پوشه اصلی پروژه داخل کانتینر
WORKDIR /app

# کپی کردن فایل‌های پروژه
COPY requirements.txt requirements.txt
COPY address_book.py address_book.py

# نصب کتابخانه‌ها
RUN pip install --no-cache-dir -r requirements.txt

# باز کردن پورت Flask
EXPOSE 5000

# اجرای برنامه
CMD ["python", "address_book.py"]

```
```
docker build -t titil-app .
```
verify
```
docker run -d -p 5050:5000 titil-app
```
push image
```
docker login
docker tag titil-app rezaabedi1365/titilrepo:latest
docker push rezaabedi1365/titilrepo:latest
```
http://<IP>:5050

### Auto Workflow
 .github/workflows/deploy.yml 
```
name: Deploy on Release Commit (develop branch)

on:
  push:
    branches:
      - develop

jobs:
  build-and-push:
    if: startsWith(github.event.head_commit.message, 'release')
    runs-on: ubuntu-latest

    steps:
      # گرفتن سورس کد
      - name: Checkout repository
        uses: actions/checkout@v3

      # استخراج نسخه از پیام کامیت (مثلا release v1.0.0 → VERSION=v1.0.0)
      - name: Extract version
        id: get_version
        run: echo "VERSION=$(echo '${{ github.event.head_commit.message }}' | cut -d' ' -f2)" >> $GITHUB_ENV

      # لاگین به Docker Hub
      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      # ساخت ایمیج و تگ‌گذاری
      - name: Build Docker image
        run: |
          IMAGE_NAME=${{ secrets.DOCKER_USERNAME }}/my-flask-app
          docker build -t $IMAGE_NAME:latest -t $IMAGE_NAME:${{ env.VERSION }} .

      # پابلیش ایمیج روی Docker Hub
      - name: Push Docker image
        run: |
          IMAGE_NAME=${{ secrets.DOCKER_USERNAME }}/my-flask-app
          docker push $IMAGE_NAME:latest
          docker push $IMAGE_NAME:${{ env.VERSION }}

      # ساخت Release در گیت‌هاب با همون نسخه
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          tag_name: ${{ env.VERSION }}
          name: Release ${{ env.VERSION }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```

خیلی خوب 👍
فرض کن روی برنچ **develop** یه کامیت می‌زنی با پیام:

```
release v2.3.1
```

با workflowی که نوشتیم، خروجی‌ها اینطوری خواهند بود:

---

### 1️⃣ استخراج نسخه

مرحله `Extract version` پیام کامیت رو پردازش می‌کنه:

```
release v2.3.1 → VERSION=v2.3.1
```

حالا `env.VERSION = v2.3.1`.

---

### 2️⃣ ساخت Docker image

دو تگ برای ایمیج ساخته میشه:

```bash
docker build -t <DOCKER_USERNAME>/my-flask-app:latest -t <DOCKER_USERNAME>/my-flask-app:v2.3.1 .
```

مثلاً اگر Docker Hub یوزرنیم `mohammad` باشه:

```
mohammad/my-flask-app:latest
mohammad/my-flask-app:v2.3.1
```

---

### 3️⃣ پوش ایمیج به Docker Hub

دو تگ بالا به Docker Hub پوش میشن:

```
docker push mohammad/my-flask-app:latest
docker push mohammad/my-flask-app:v2.3.1
```

حالا روی Docker Hub هم `latest` داری، هم `v2.3.1`.

---

### 4️⃣ ساخت Release روی GitHub

Release با همون نسخه ساخته میشه:

* **Tag:** `v2.3.1`
* **Name:** `Release v2.3.1`
* لینک Release توی GitHub قابل مشاهده است و میشه فایل‌ها یا توضیحات اضافی اضافه کرد.

---

💡 نتیجه:

* هر وقت پیام کامیت `release <version>` باشه، ایمیج جدید میاد و پابلیش میشه.
* Release روی GitHub هم همزمان ساخته میشه و کاملاً منطبق با نسخه.

---
### Manual Workflow
```
name: Deploy on Release

# فعال‌سازی اجرای دستی
on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to release (e.g., v1.0.0)'
        required: true
        default: 'v1.0.0'

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      # گرفتن سورس کد
      - name: Checkout repository
        uses: actions/checkout@v3

      # تنظیم نسخه از ورودی دستی
      - name: Set version
        run: echo "VERSION=${{ github.event.inputs.version }}" >> $GITHUB_ENV

      # لاگین به Docker Hub
      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      # ساخت ایمیج و تگ‌گذاری
      - name: Build Docker image
        run: |
          IMAGE_NAME=${{ secrets.DOCKER_USERNAME }}/my-flask-app
          docker build -t $IMAGE_NAME:latest -t $IMAGE_NAME:${{ env.VERSION }} .

      # پابلیش ایمیج روی Docker Hub
      - name: Push Docker image
        run: |
          IMAGE_NAME=${{ secrets.DOCKER_USERNAME }}/my-flask-app
          docker push $IMAGE_NAME:latest
          docker push $IMAGE_NAME:${{ env.VERSION }}

      # ساخت Release در گیت‌هاب
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          tag_name: ${{ env.VERSION }}
          name: Release ${{ env.VERSION }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```


✅ تغییرات اصلی:

1. جای `push` روی `develop`، از `workflow_dispatch` استفاده شد تا اجرای دستی امکان‌پذیر باشد.
2. نسخه (`VERSION`) از طریق ورودی دستی (`inputs.version`) دریافت می‌شود.
3. حذف شرط `startsWith(github.event.head_commit.message, 'release')`، چون الان دستی کنترل می‌شود.

با این کار می‌توانی هر موقع خواستی از بخش **Actions** در GitHub Workflow را اجرا کنی و نسخه مورد نظر را مشخص کنی.















### Manual & Auto workflow
```
name: Deploy Release

on:
  # اجرای خودکار روی کامیت release روی develop
  push:
    branches:
      - develop
  # امکان اجرای دستی
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to release (e.g., v1.0.0)'
        required: false

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      # گرفتن سورس کد
      - name: Checkout repository
        uses: actions/checkout@v3

      # تعیین نسخه
      - name: Set version
        run: |
          if [ -n "${{ github.event.inputs.version }}" ]; then
            # اگر اجرای دستی بود، از ورودی استفاده کن
            echo "VERSION=${{ github.event.inputs.version }}" >> $GITHUB_ENV
          else
            # اگر اجرای خودکار بود، از پیام کامیت استخراج کن
            VERSION=$(echo "${{ github.event.head_commit.message }}" | cut -d' ' -f2)
            echo "VERSION=$VERSION" >> $GITHUB_ENV
          fi

      # لاگین به Docker Hub
      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      # ساخت ایمیج Docker و تگ‌گذاری
      - name: Build Docker image
        run: |
          IMAGE_NAME=${{ secrets.DOCKER_USERNAME }}/my-flask-app
          docker build -t $IMAGE_NAME:latest -t $IMAGE_NAME:${{ env.VERSION }} .

      # پابلیش روی Docker Hub
      - name: Push Docker image
        run: |
          IMAGE_NAME=${{ secrets.DOCKER_USERNAME }}/my-flask-app
          docker push $IMAGE_NAME:latest
          docker push $IMAGE_NAME:${{ env.VERSION }}

      # ایجاد Release در GitHub
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          tag_name: ${{ env.VERSION }}
          name: Release ${{ env.VERSION }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

```
✅ قابلیت‌ها:

1. وقتی commit ای با پیام `release v1.0.0` روی شاخه `develop` ایجاد شود، خودکار اجرا می‌شود.
2. امکان اجرای دستی از **Actions → Run workflow** با ورودی `version` وجود دارد.
3. Docker image هم بر اساس نسخه تگ‌گذاری می‌شود و هم `latest` پوش می‌شود.
4. GitHub Release هم بر اساس نسخه ساخته می‌شود.





