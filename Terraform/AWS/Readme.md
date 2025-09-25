حتماً 🙂 این یک **مثال ساده Terraform برای AWS** است که یک **EC2 Instance** ایجاد می‌کند و روی آن **Nginx نصب** می‌کند.

---

## فایل `main.tf`

```hcl
provider "aws" {
  region = "us-east-1"  # منطقه AWS خودت را تنظیم کن
}

# ایجاد یک key pair برای SSH
resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# ایجاد Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ایجاد EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 در us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.web_sg.name]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "Terraform-EC2-Web"
  }
}
```

---

### 🔹 مراحل اجرا

1. **init Terraform**

```bash
terraform init
```

2. **بررسی پلن**

```bash
terraform plan
```

3. **اعمال پلن و ساخت EC2**

```bash
terraform apply
```

* بعد از تایید، یک **EC2 Instance** ساخته می‌شود.
* Nginx روی آن نصب شده و سرویس فعال است.
* آدرس عمومی EC2 را می‌توانی در مرورگر باز کنی و صفحه پیش‌فرض Nginx را ببینی.

---

### 🔹 نکات مهم

* **AMI** را مطابق منطقه AWS خودت تغییر بده.
* **Key Pair** باید از قبل ساخته شده باشد یا همان مسیر کلید SSH خودت را بدهی.
* Security Group فقط پورت 22 و 80 باز هستند، می‌توانی برای HTTPS پورت 443 اضافه کنی.
* Provisioner `remote-exec` روی سیستم Ubuntu کار می‌کند و می‌توانی دستورات نصب نرم‌افزار دلخواه را اضافه کنی.

---

اگر بخواهی، می‌توانم یک **نسخه پیشرفته AWS با چند EC2، load balancer و auto-scaling group** آماده کنم که مستقیم قابل اجرا باشد.

می‌خوای بسازم؟
