* تست‌های **.NET Core** با JUnit report
* بیلد و push به **Nexus Docker Registry**
* دیپلوی با **Helm** روی Kubernetes
* استفاده از متغیرهای امن GitLab

---

## 📄 `.gitlab-ci.yml` آماده

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

