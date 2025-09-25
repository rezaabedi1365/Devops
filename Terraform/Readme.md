# Infrastructure as Code (IaC)

#### Install
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
```

### HCL (HashiCorp Configuration Language)

می‌توانی از آن برای **ایجاد و مدیریت زیرساخت به‌صورت کد (Infrastructure as Code)** استفاده کنی. این ابزار بسیار منعطف و قدرتمند است.

---

## 🔹 حوزه‌های اصلی استفاده

1. **مدیریت سرویس‌های ابری (Cloud)**

   * AWS: ایجاد EC2, S3, VPC, RDS و غیره
   * Azure: VM, Storage Account, Virtual Network
   * GCP: Compute Engine, Cloud Storage, Firewalls
   * همه این منابع را می‌توانی با **فایل‌های HCL (HashiCorp Configuration Language)** تعریف و یکجا مدیریت کنی.

2. **مدیریت شبکه و زیرساخت داخلی**

   * VMware vSphere
   * OpenStack
   * Kubernetes clusters (با provider Kubernetes)
   * تنظیم شبکه‌های خصوصی، Load Balancer و Storage

3. **Provisioning و Configuration پایه‌ای**

   * نصب و راه‌اندازی ماشین‌ها یا containerها
   * ایجاد دیتابیس، کاربر، رول‌ها
   * Terraform خودش provision را تا حدی انجام می‌دهد، ولی برای عملیات دقیق‌تر می‌توانی با Ansible یا scripts ترکیب کنی.

4. **مدیریت چند محیط (Dev, Test, Prod)**

   * با تعریف environment-specific variables و workspaces می‌توانی زیرساخت‌های مشابه را در چند محیط مدیریت کنی بدون تکرار کد.

5. **Automation و CI/CD**

   * Terraform را می‌توان در GitLab CI, GitHub Actions یا Jenkins اجرا کرد تا **زیرساخت به‌صورت خودکار** ساخته یا تغییر کند.

---



