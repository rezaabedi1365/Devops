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
  verify_certificates: false  #ignore certificate check
  active_directory: true
  allow_username_or_email_login: true
  lowercase_usernames: false
  block_auto_created_users: false

  base: 'DC=faradis,DC=net'          # این باعث میشه کل دامنه سرچ بشه
  group_base: 'DC=faradis,DC=net'    # گروه‌ها هم از کل دامنه گرفته میشن
  user_filter: '(memberOf=CN=GitLab-Users,OU=Groups,DC=faradis,DC=net)'   # فقط اعضای این گروه
  # user_filter: '(|(memberOf=CN=GitLab-Users,OU=Groups,DC=faradis,DC=net)(memberOf=CN=DevOps,OU=Groups,DC=faradis,DC=net))'    #اگر چند گروه داشتیم 

  admin_group: 'GitLab-Admins'       # گروهی که ادمین میشه
  attributes:
    username: ['uid', 'sAMAccountName']
    email:    ['mail', 'userPrincipalName']
    name:     'cn'
    first_name: 'givenName'
    last_name:  'sn'
EOS
```
verify:
```
gitlab-rake gitlab:ldap:check

apt install ldap-utils
ldapsearch -x -H ldap://dc01.faradis.net \
  -D "CN=gitlab-svc,OU=Faradis Service Users,OU=Faradis,DC=faradis,DC=net" \
  -w 'NewStrongPasswordHere' \
  -b "DC=faradis,DC=net" "(sAMAccountName=testuser)"
```
```
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
```
### ldaps
add DC Certificate to gitlab server
```
sudo cp ca.crt /usr/local/share/ca-certificates/faradis-ca.crt
sudo update-ca-certificates
```
ldaps
```
verify_certificates: true
```

# Email Configuration
```
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "mail.faradis.net"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "gitlab@faradis.net"        # یوزری که روی میل‌سرور ساختی
gitlab_rails['smtp_password'] = "YourStrongPassword"         # پسورد اون یوزر
gitlab_rails['smtp_domain'] = "faradis.net"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false

# فرستنده پیش‌فرض ایمیل‌ها
gitlab_rails['gitlab_email_from'] = 'gitlab@faradis.net'
gitlab_rails['gitlab_email_display_name'] = 'GitLab Faradis'
gitlab_rails['gitlab_email_reply_to'] = 'noreply@faradis.net'

```
if have tls
```
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_tls'] = true
gitlab_rails['smtp_enable_starttls_auto'] = false
```
```
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
```
