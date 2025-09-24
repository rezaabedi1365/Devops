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
```

```
/etc/gitlab/ssl/<your-domain>.crt
/etc/gitlab/ssl/<your-domain>.key
```
```
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
```

# ldap
nano /etc/gitlab/gitlab.
```
gitlab_rails['ldap_enabled'] = true
gitlab_rails['ldap_servers'] = YAML.load <<-EOS
main:
  label: 'Active Directory'
  host: 'dc01.faradis.net'           # آدرس Domain Controller
  port: 389
  uid: 'sAMAccountName'
  bind_dn: 'CN=gitlab-svc,OU=Faradis Service Users,OU=Faradis,DC=faradis,DC=net'  # یوزر سرویس
  password: 'YourStrongPassword'
  encryption: 'start_tls'
  verify_certificates: true
  active_directory: true
  allow_username_or_email_login: true
  lowercase_usernames: false
  block_auto_created_users: false
  base: 'DC=faradis,DC=net'          # این باعث میشه کل دامنه سرچ بشه
  group_base: 'DC=faradis,DC=net'    # گروه‌ها هم از کل دامنه گرفته میشن
  admin_group: 'GitLab-Admins'       # گروهی که ادمین میشه
  attributes:
    username: ['uid', 'sAMAccountName']
    email:    ['mail', 'userPrincipalName']
    name:     'cn'
    first_name: 'givenName'
    last_name:  'sn'
EOS
```
# Email Configuration
```
```

