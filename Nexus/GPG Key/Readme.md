# gpg key
- generate pgp key
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
- show key ID
```
gpg --list-keys nexus@example.com
```
- show private key
```
gpg --armor --export-secret-keys nexus@example.com > ./pgp/private.key
```
- Eport public key
```
gpg --armor --export nexus@example.com > ./pgp/public.key
```
### armored signature
```
gpg --armor --detach-sign -u 0123456789ABCDEF myartifact-1.0.jar
```
```
gpg --batch --yes --pinentry-mode loopback --passphrase "$GPG_PASSPHRASE" \
    --armor --detach-sign -u 0123456789ABCDEF myartifact-1.0.jar

```

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
