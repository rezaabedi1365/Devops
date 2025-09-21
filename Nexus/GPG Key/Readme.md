# gpg key
## path
- new
    * /etc/apt/keyrings       #official deb pakcage 
    * /usr/share/keyrings     #costum deb package
- old 
    * /etc/apt/trusted.gpg    #oldest path for store gpg
    * /etc/apt/teusted.gpg.d/ #after tristed.gpg path for solve single file 

## file format
- .asc  #clear
- .gpg  #encriypted
- 
### Method1: .gpg
- download .asc and convert to gpg
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
### Method2: .asc
- download .asc and use .asc
```
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
```
--------------------------------------------------------------------------------------------------------
# generate pgp key
```
gpg --full-generate-key
```
- generate gpg key with script
```
mkdir -p ./pgp

gpg --batch --gen-key <<EOF
Key-Type: RSA
Key-Length: 4096
Name-Real: Nexus Repo Signing
Name-Email: nexus@example.com
Expire-Date: 0
%no-protection
%commit
EOF
```
### Export pgp key
show key ID
```
gpg --list-keys nexus@example.com
```
Export subkeys (Recomended for privatekey)
```
gpg --armor --export-secret-subkeys "nexus@example.com" > /root/composfiles/nexus/private-subkeys.asc
```
Export private key Plantext
```
gpg --armor --export-secret-keys nexus@example.com > ./pgp/private.key
```
Eport public key
```
gpg --armor --export nexus@example.com > ./pgp/public.key
```
### Import pgp key
```
gpg --decrypt /root/composfiles/nexus/private-subkeys.asc.gpg | gpg --import
```
-------------------------------------------------------------------------------------------
# sign packhage with gpg (armored signature)
```
gpg --armor --detach-sign -u 0123456789ABCDEF myartifact-1.0.jar
```
```
gpg --batch --yes --pinentry-mode loopback --passphrase "$GPG_PASSPHRASE" \
    --armor --detach-sign -u 0123456789ABCDEF myartifact-1.0.jar

```

-----------------------------------------------------------------------------------------
# Transfer gpgkey to client
- Eport public key
```
gpg --armor --export nexus@example.com > ./pgp/public.key
```
- upload gpg key in server
```
curl -u admin:pass --upload-file nexus-repo.gpg.key \
  http://nexus.example.com/repository/keys/nexus-repo.gpg.key
```

- Download gpgkey in client
```
curl -fsSL http://nexus.example.com/repository/keys/nexus-repo.gpg.key | sudo tee /etc/apt/trusted.gpg.d/nexus-repo.gpg > /dev/null
```
