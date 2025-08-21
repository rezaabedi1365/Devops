# Variable

- Predefined Variables → GitLab خودش می‌ده
- Custom Variables → تو تعریف می‌کنی (توی YAML یا UI)
- Group/Instance level Variables → برای کل گروپ/سازمان
- File variables → برای فایل‌ها (cert/kubeconfig)
- Protected Variables → فقط روی branch/tag محافظت‌شده
- Masked Variables → مخفی تو لاگ
- Job scoped Variables → فقط تو همون

----------------------------------------------------
## Predefined Variables

----------------------------------------------------

این یه **چیت‌شیت متغیرهای GitLab CI/CD** هست که می‌تونی تو pipeline و پروژه استفاده کنی، مخصوص داکر، Kubernetes، و .NET Core:

---

## 🔹 متغیرهای عمومی GitLab CI/CD

| متغیر                 | توضیح                                | مثال                                  |
| --------------------- | ------------------------------------ | ------------------------------------- |
| `CI`                  | همیشه `true` وقتی pipeline اجرا میشه | `true`                                |
| `CI_COMMIT_SHA`       | SHA کامل commit                      | `4a7d3e...`                           |
| `CI_COMMIT_SHORT_SHA` | 8 کاراکتر اول SHA                    | `4a7d3e1f`                            |
| `CI_COMMIT_REF_NAME`  | نام branch یا tag                    | `main`                                |
| `CI_COMMIT_TAG`       | اگر commit تگ باشه، نام تگ           | `v1.0.0`                              |
| `CI_PIPELINE_ID`      | شناسه pipeline                       | `1234`                                |
| `CI_JOB_ID`           | شناسه job                            | `5678`                                |
| `CI_PROJECT_PATH`     | path پروژه                           | `username/my-app`                     |
| `CI_PROJECT_URL`      | URL پروژه                            | `https://gitlab.com/username/my-app`  |
| `CI_REGISTRY`         | آدرس registry GitLab                 | `registry.gitlab.com`                 |
| `CI_REGISTRY_IMAGE`   | مسیر پروژه در GitLab Registry        | `registry.gitlab.com/username/my-app` |
| `CI_JOB_TOKEN`        | توکن دسترسی به registry              | (مقدار خودکار)                        |

---

## 🔹 متغیرهای Docker / Container Registry

| متغیر                  | توضیح              | مثال                                                                     |
| ---------------------- | ------------------ | ------------------------------------------------------------------------ |
| `DOCKER_IMAGE`         | مسیر ایمیج         | `registry.gitlab.com/username/my-app` یا `nexus.example.com/repo/my-app` |
| `CI_REGISTRY_USER`     | یوزرنیم برای login | `gitlab-ci-token` یا یوزر Nexus                                          |
| `CI_REGISTRY_PASSWORD` | پسورد یا توکن      | `$CI_JOB_TOKEN` یا توکن Nexus                                            |
| `DOCKER_TAG`           | تگ ایمیج           | `$CI_COMMIT_SHORT_SHA` یا `latest`                                       |

---

## 🔹 متغیرهای Kubernetes / Helm

| متغیر              | توضیح                     | مثال                      |
| ------------------ | ------------------------- | ------------------------- |
| `KUBE_SERVER`      | آدرس API سرور کلاستر      | `https://k8s.example.com` |
| `KUBE_TOKEN`       | سرویس اکانت کلاستر        | `eyJhbGciOi...`           |
| `KUBE_CA_PEM_FILE` | CA certificate base64 شده | `/tmp/ca.crt`             |
| `KUBE_NAMESPACE`   | namespace پیش‌فرض         | `default`                 |
| `KUBE_CONTEXT`     | نام context kubectl       | `gitlab-cluster`          |
| `RELEASE_NAME`     | نام release در Helm       | `my-app`                  |

---

## 🔹 متغیرهای .NET Core / Pipeline

| متغیر             | توضیح              | مثال                |
| ----------------- | ------------------ | ------------------- |
| `DOTNET_VERSION`  | ورژن SDK           | `7.0`               |
| `DOTNET_ROOT`     | مسیر نصب SDK       | `/usr/share/dotnet` |
| `DOTNET_CLI_HOME` | مسیر home برای CLI | `/tmp`              |

---

## 🔹 توصیه‌ها

1. متغیرهای **حساس** مثل پسورد، توکن، کلید CA حتماً تو GitLab → Settings → CI/CD → Variables ست کن و **masked/protected** باشه.
2. برای rollback راحت، همیشه **versioned tag** و **latest tag** رو با هم push کن.
3. برای Helm، متغیر `RELEASE_NAME` و `KUBE_NAMESPACE` ثابت باشه تا pipeline قابل پیش‌بینی باشه.

---

