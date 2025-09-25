حتماً 🙂 این یک **مثال ساده Terraform برای Kubernetes** است که یک **Deployment و Service** ایجاد می‌کند تا یک Nginx Pod روی کلاستر Kubernetes اجرا شود.

---

## فایل `main.tf`

```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"  # مسیر kubeconfig خودت
}

# ایجاد namespace
resource "kubernetes_namespace" "example" {
  metadata {
    name = "example"
  }
}

# ایجاد Deployment برای Nginx
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          ports {
            container_port = 80
          }
        }
      }
    }
  }
}

# ایجاد Service برای دسترسی به Deployment
resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer" # اگر روی cloud اجرا می‌کنید، یک LB ایجاد می‌کند
  }
}
```

---

### 🔹 گام‌های اجرا

1. **init Terraform**

```bash
terraform init
```

2. **بررسی پلن**

```bash
terraform plan
```

3. **اعمال پلن و ایجاد منابع**

```bash
terraform apply
```

* بعد از تایید، namespace، deployment و service ساخته می‌شوند.
* اگر کلاستر روی cloud (مثل AWS EKS, GCP GKE یا Azure AKS) باشد، Service نوع LoadBalancer یک IP عمومی می‌دهد.
* در محیط محلی (مثل minikube)، می‌توانی از `kubectl port-forward` برای دسترسی به Nginx استفاده کنی.

---

💡 نکات:

* Provider Kubernetes نیاز به **kubeconfig معتبر** دارد.
* تعداد replicas را می‌توانی تغییر دهی تا چند Pod همزمان اجرا شود.
* این مثال پایه‌ای است و می‌توانی config maps، secrets، volumes و ingress را هم اضافه کنی.

---

اگر بخواهی، می‌توانم یک **نسخه پیشرفته Terraform برای Kubernetes با چند Deployment، Ingress و TLS خودکار** آماده کنم که مستقیم روی cluster اجرا شود و آماده Production باشد.

می‌خوای بسازم؟
