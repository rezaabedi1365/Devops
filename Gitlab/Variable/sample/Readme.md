* تست‌های **.NET Core** با JUnit report
* بیلد و push به **Nexus Docker Registry**
* دیپلوی با **Helm** روی Kubernetes
* استفاده از متغیرهای امن GitLab

---

##  .gitlab-ci.yml

```yaml
stages:
  - test
  - build
  - deploy

# -----------------------------
# متغیرهای pipeline
# -----------------------------
variables:
  DOCKER_IMAGE: "nexus.example.com/docker-repo/my-app"
  DOTNET_VERSION: "7.0"
  KUBE_NAMESPACE: "default"
  RELEASE_NAME: "my-app"

# -----------------------------
# مرحله تست .NET Core
# -----------------------------
test:
  stage: test
  image: mcr.microsoft.com/dotnet/sdk:$DOTNET_VERSION
  script:
    - dotnet restore
    - dotnet build --no-restore
    - dotnet test --no-build --logger "junit;LogFilePath=test-results.xml" --verbosity normal
  artifacts:
    when: always
    reports:
      junit: test-results.xml
    paths:
      - test-results.xml
  only:
    - merge_requests
    - main

# -----------------------------
# مرحله Build & Push Docker
# -----------------------------
build-and-push:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    # لاگین به Nexus
    - docker login -u $NEXUS_USER -p $NEXUS_PASSWORD nexus.example.com
    # بیلد ایمیج
    - docker build -t $DOCKER_IMAGE:$CI_COMMIT_SHORT_SHA .
    - docker push $DOCKER_IMAGE:$CI_COMMIT_SHORT_SHA
    # تگ latest
    - docker tag $DOCKER_IMAGE:$CI_COMMIT_SHORT_SHA $DOCKER_IMAGE:latest
    - docker push $DOCKER_IMAGE:latest
  only:
    - main
  dependencies:
    - test

# -----------------------------
# مرحله Deploy با Helm
# -----------------------------
deploy:
  stage: deploy
  image: alpine/helm:3.14.0
  script:
    - helm upgrade --install $RELEASE_NAME ./helm-chart \
        --namespace $KUBE_NAMESPACE \
        --set image.repository=$DOCKER_IMAGE \
        --set image.tag=$CI_COMMIT_SHORT_SHA
  only:
    - main
  dependencies:
    - build-and-push
```

---

## 🔹 متغیرهای GitLab که باید تعریف کنی

| متغیر              | توضیح                                          | نوع                   |
| ------------------ | ---------------------------------------------- | --------------------- |
| `NEXUS_USER`       | یوزرنیم برای login به Nexus                    | **Protected, Masked** |
| `NEXUS_PASSWORD`   | پسورد یا توکن Nexus                            | **Protected, Masked** |
| `KUBE_SERVER`      | URL API سرور Kubernetes                        | **Protected**         |
| `KUBE_TOKEN`       | سرویس اکانت Kubernetes                         | **Protected, Masked** |
| `KUBE_CA_PEM_FILE` | CA certificate base64 شده                      | **Protected, Masked** |
| `KUBE_NAMESPACE`   | namespace پیش‌فرض (اختیاری، default=`default`) | Protected             |

---

## 🔹 نکات کلیدی

1. تست‌ها روی merge request و main اجرا میشن، build و deploy فقط روی main.
2. artifact `test-results.xml` گزارش تست‌ها رو تو GitLab UI نشون میده.
3. اگر Nexus TLS نداره، باید registry رو با `--insecure-registry` به داکر اضافه کنی.
4. Helm chart باید در پوشه `./helm-chart` موجود باشه و `values.yaml` image repository و tag داشته باشه.

---










----------------------------------------

تو **GitLab** متغیرهای CI/CD رو می‌تونی از طریق UI یا `.gitlab-ci.yml` تعریف کنی. برای pipelineهایی که شامل **سرویس‌های حساس** مثل Nexus یا Kubernetes هستن، بهتره از **GitLab CI/CD Variables** استفاده کنی و آنها را **Masked** و **Protected** کنی.

---

## ۱️⃣ تعریف متغیرها از طریق UI

1. به پروژه برو → **Settings → CI/CD → Variables**
2. روی **“Add variable”** کلیک کن.
3. فیلدها رو پر کن:

| فیلد          | توضیح                                                          |
| ------------- | -------------------------------------------------------------- |
| **Key**       | نام متغیر، مثال: `NEXUS_USER`                                  |
| **Value**     | مقدار متغیر، مثال: `admin`                                     |
| **Type**      | Variable (معمولی) یا File (برای فایل‌های base64 یا kubeconfig) |
| **Protected** | فقط روی branchهای Protected (مثلاً main) در دسترس است          |
| **Masked**    | مقدار متغیر در logها نمایش داده نمی‌شود                        |

مثال متغیرهای مورد نیاز ما:

| Key                 | Value                     | توضیح                          |
| ------------------- | ------------------------- | ------------------------------ |
| NEXUS\_USER         | `admin`                   | یوزرنیم لاگین به Nexus         |
| NEXUS\_PASSWORD     | `mypassword`              | پسورد یا توکن                  |
| KUBE\_TOKEN         | `<token>`                 | سرویس اکانت Kubernetes         |
| KUBE\_SERVER        | `https://k8s.example.com` | API Server                     |
| KUBE\_CA\_PEM\_FILE | Base64 cert               | اگر نیاز به CA certificate هست |

> توجه: متغیرهایی که **Masked** هستن، تو لاگ pipeline نشون داده نمی‌شن.

---

## ۲️⃣ تعریف متغیرها در `.gitlab-ci.yml` (غیر حساس)

برای متغیرهای غیر حساس (مثل نام release یا namespace) می‌توانی مستقیم در فایل YAML تعریف کنی:

```yaml
variables:
  DOCKER_IMAGE: "nexus.example.com/docker-repo/my-app"
  KUBE_NAMESPACE: "default"
  RELEASE_NAME: "my-app"
  DOTNET_VERSION: "7.0"
```

> ⚠️ هیچوقت متغیرهای حساس مثل پسورد یا توکن را در YAML مستقیم ننویس، همیشه از **GitLab UI** استفاده کن.

---

## ۳️⃣ استفاده از متغیرها در pipeline

در script هر job می‌توانی از متغیرها استفاده کنی:

```yaml
script:
  - docker login -u $NEXUS_USER -p $NEXUS_PASSWORD nexus.example.com
  - helm upgrade --install $RELEASE_NAME ./helm-chart --namespace $KUBE_NAMESPACE --set image.repository=$DOCKER_IMAGE
```

> `$VAR_NAME` = فراخوانی متغیر

---



