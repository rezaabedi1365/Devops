

```
stages:
  - build
# مرحله ساخت (اگر وابستگی‌هایی داریم، نصب می‌کنیم)
build_job:
  stage: build
  image: python:3.9    # از Docker image رسمی Python استفاده می‌کنیم
  script:
    - echo "Setting up the Python environment..."
    - pip install --upgrade pip
    - pip install -r requirements.txt    # نصب وابستگی‌های پروژه
# مرحله تست
  artifacts:
    paths:
      - reports/          # ذخیره نتایج تست‌ها
```
