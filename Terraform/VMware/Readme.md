
عالی 🙂 این یک **نمونه Terraform کامل برای ایجاد چند VM در VMware vSphere با نصب Nginx و تنظیم اولیه firewall ساده** است.

---

## فایل `main.tf`

```hcl
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "YourPassword"
  vsphere_server = "vcenter.example.com"

  allow_unverified_ssl = true
}

# دیتاسنتر
data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

# datastore
data "vsphere_datastore" "datastore" {
  name          = "Datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# cluster
data "vsphere_compute_cluster" "cluster" {
  name          = "Cluster1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# شبکه
data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# template
data "vsphere_virtual_machine" "template" {
  name          = "UbuntuTemplate"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# ایجاد چند VM با count
resource "vsphere_virtual_machine" "vm" {
  count            = 2
  name             = "terraform-test-vm-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 2048
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  # نصب Nginx و فعال کردن firewall
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx ufw",
      "sudo ufw allow 'Nginx HTTP'",
      "sudo ufw --force enable",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"               # یوزر VM template
      private_key = file("~/.ssh/id_rsa")  # کلید خصوصی SSH
      host        = self.default_ip_address
    }
  }
}
```

---

### 🔹 نحوه اجرا

1. **init Terraform**

```bash
terraform init
```

2. **بررسی پلن**

```bash
terraform plan
```

3. **اعمال پلن و ساخت VM ها**

```bash
terraform apply
```

* دو VM ساخته می‌شود و روی هر کدام **Nginx نصب و فعال می‌شود**.
* firewall با UFW روی HTTP تنظیم شده و سرویس فعال است.

---

💡 نکات:

* تعداد VM ها با `count = 2` مشخص شده، می‌توانی افزایش دهی.
* نام‌ها به صورت `terraform-test-vm-1` و `terraform-test-vm-2` ساخته می‌شوند.
* SSH key باید به VM template دسترسی داشته باشد.
* Provisioner می‌تواند نصب نرم‌افزار یا کانفیگ‌های دیگر را هم اضافه کند.

---

اگر بخواهی، می‌توانم یک **نسخه پیشرفته با load balancer داخلی Nginx بین VM ها و تنظیمات تولید (Production)** هم آماده کنم که مستقیم قابل اجرا باشد.

می‌خوای بسازم؟
