
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

verify nginx config for external_url :
- /var/opt/gitlab/nginx/conf/gitlab-http.conf
```
server {
  listen *:443 ssl http2;
  server_name gitlab.faratest.net;

  ssl_certificate /etc/gitlab/ssl/bundle-fullchain.crt;
  ssl_certificate_key /etc/gitlab/ssl/private.key;

  location / {
    proxy_pass http://gitlab-workhorse;
    ...
  }
}

```
verify nginx config for registry_external_url :
- nano /var/opt/gitlab/nginx/conf/gitlab-registry.conf
```
server {
  listen *:443 ssl http2;
  server_name gitlabregistry.faratest.net;

  ssl_certificate /etc/gitlab/ssl/bundle-fullchain.crt;
  ssl_certificate_key /etc/gitlab/ssl/private.key;

  location /v2/ {
    proxy_pass http://localhost:5000;
    ...
  }
}

```
- verify:
```
sudo gitlab-ctl status
sudo ss -tlnp | grep -E "443|5000"
sudo cat /var/log/gitlab/nginx/error.log
sudo cat /var/log/gitlab/registry/current
```
### docker login
<img width="1726" height="830" alt="image" src="https://github.com/user-attachments/assets/351d86c3-addb-45d8-8eae-73e356f840f5" />

```
docker login gitlabregistry.faradis.net -u <GitLab-username> -p <Personal-Access-Token>
docker login gitlabregistry.faradis.net -u root -p glpat-svrGJgzJsQvxLGYGFobb
```
- save in ./.docker/config.json

### push image

```
docker tag <ImageName> <name>:<tag>
docker tag nginx:latest gitlabregistry.faradis.net/pushgroup/pushproject:v_1-0-0
```

```
docker push <registry>/<group>/<project>:<tag>
docker push gitlabregistry.faradis.net/pushgroup/pushproject:v_1-0-0
```

### pull image

```
docker pull registry.example.com:5005/group/project:latest
```
### Remove tag & Remove image
- remove tag
```
docker rmi <ImageName>:tag
```
- remove image
```
docker image rmi <ImageName>:<tag>
```
<img width="1423" height="843" alt="image" src="https://github.com/user-attachments/assets/8d755b97-d1db-47b6-9f23-f5431cb5e85f" />

