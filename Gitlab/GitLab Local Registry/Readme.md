

```
sudo nano /etc/gitlab/gitlab.rb
```
- Crate A Record in DNS and after edit gitlab.rb file
```
registry_external_url 'https://gitlab.faratest.net'
registry_nginx['ssl_certificate'] = "/etc/ssl/certs/<Yourcert>.crt"
registry_nginx['ssl_certificate_key'] = "/etc/ssl/private/<YourKey>.key"
```
```
sudo gitlab-ctl reconfigure
```
- push image
```
docker tag my-image registry.example.com/group/project:latest
docker push registry.example.com/group/project:latest
```
-pull image
```
docker pull registry.example.com/group/project:latest
```

