
```
stages:
  - build

build_job:
  stage: build
  image: maven:3.8.4-jdk-11    # از ایمیج Docker رسمی Maven استفاده می‌کنیم
  script:
    - echo "Building Java project with Maven..."
    - mvn clean install      # بیلد پروژه با Maven
  artifacts:
    paths:
      - target/             # فایل‌های خروجی در دایرکتوری target ذخیره می‌شوند

```
