
## GitLab Local Registry
```
sudo nano /etc/gitlab/gitlab.rb
```
- Crate A Record in DNS and after edit gitlab.rb file
```
# دامنه GitLab (UI اصلی)
external_url 'https://gitlab.example.com'
```
```
# Registry داخلی GitLab
registry_external_url 'https://registry.example.com'

# فعال کردن Registry
gitlab_rails['registry_enabled'] = true
gitlab_rails['registry_host'] = "registry.example.com"
gitlab_rails['registry_port'] = "5005" 
gitlab_rails['registry_path'] = "/var/opt/gitlab/gitlab-rails/shared/registry"

# Nginx برای Registry
registry_nginx['enable'] = true
registry_nginx['listen_https'] = true
registry_nginx['ssl_certificate'] = "/etc/gitlab/ssl/registry.example.com.crt"
registry_nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/registry.example.com.key"

```
```
sudo gitlab-ctl reconfigure
```
- bundle-fullchain crt
```
-----BEGIN CERTIFICATE-----
(Server certificate)
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
(Intermediate certificate)
-----END CERTIFICATE-----
```
- Privatekey (clear_
```
-----BEGIN PRIVATE KEY-----
(Your private key)
-----END PRIVATE KEY-----
```
### push image
```
docker tag my-image registry.example.com:5005/group/project:latest
docker push registry.example.com:5005/group/project:latest
```
### pull image
```
docker pull registry.example.com:5005/group/project:latest
```

