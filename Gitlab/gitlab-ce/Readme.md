# Install
## Gitlab-ce commounity Edition
- install gitlab-ce cumunity Edition
```
sudo apt update && sudo apt upgrade -y

sudo apt install -y curl openssh-server ca-certificates tzdata perl

curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash


sudo EXTERNAL_URL="http://10.10.12.18" apt install gitlab-ce -y

```

- root password path
```
cat /etc/gitlab/initial_root_password
```
- gitlab config
```
nano /etc/gitlab/gitlab.rb
```

## Gitlab Certificate 
```
nano /etc/gitlab/gitlab.rb
```
```
external_url 'https://gitlabregistry.faradis.net'
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/bundle-fullchain.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/private.key"
external_url 'https://gitlabregistry.faradis.net'
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/bundle-fullchain.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/private.key"
```

```
/etc/gitlab/ssl/<your-domain>.crt
/etc/gitlab/ssl/<your-domain>.key
```
```
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
```



