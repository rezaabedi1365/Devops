
## GitLab Local Registry
 copy your certificate file
```
sudo chown root:root /etc/gitlab/ssl/*.crt /etc/gitlab/ssl/*.*
sudo chmod 600 /etc/gitlab/ssl/*.crt /etc/gitlab/ssl/*.*
```

bundle-fullchai.crt format
```
-----BEGIN CERTIFICATE-----
(Server certificate)
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
(Intermediate certificate)
-----END CERTIFICATE-----
```
private.key format
```
-----BEGIN PRIVATE KEY-----
(Your private key)
-----END PRIVATE KEY-----

```
### Edit /etc/gitlab/gitlab.rb file
```
sudo nano /etc/gitlab/gitlab.rb
```

Crate A Record in DNS or add record in /etc/hosts and after edit gitlab.rb file

```
# دامنه GitLab (UI اصلی)
external_url 'https://gitlabregistry.faratest.net'
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/bundle-fullchain.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/private.key"
```

- important: external_url = registry_external_url
```
# Registry داخلی GitLab
registry_external_url 'https://gitlabregistry.faratest.net'

# فعال کردن Registry
gitlab_rails['registry_enabled'] = true
gitlab_rails['registry_host'] = "gitlabregistry.faratest.net"
gitlab_rails['registry_path'] = "/var/opt/gitlab/gitlab-rails/shared/registry"

# Nginx برای Registry
registry_nginx['enable'] = true
registry_nginx['listen_https'] = true
registry_nginx['ssl_certificate'] = "/etc/gitlab/ssl/bundle-fullchain.crt"
registry_nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/private.key"

letsencrypt['enable'] = false
```
```
sudo gitlab-ctl reconfigure
```
- verify:
```
sudo gitlab-ctl status
sudo ss -tlnp | grep -E "443|5005"
sudo cat /var/log/gitlab/nginx/error.log
sudo cat /var/log/gitlab/registry/current
```

-----BEGIN PRIVATE KEY-----
(Your private key)
-----END PRIVATE KEY-----
```
### push image
```
docker login gitlabregistry.faratest.net
```
```
docker tag my-image gitlabregistry.faratest.net/group/project:latest
docker push gitlabregistry.faratest.net/group/project:latest
```
### pull image
```
docker login gitlabregistry.faratest.net
```
```
docker pull registry.example.com:5005/group/project:latest
```

