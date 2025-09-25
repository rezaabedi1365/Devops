# Install
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
```

# Semaphore UI
```
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ansible-semaphore/semaphore
sudo apt-get update
```
```
sudo apt-get install semaphore
```
```
semaphore setup
```
```
semaphore server
```
http://localhost:3000
### Docker compose 
```
version: '3'

services:
  semaphore:
    image: ansiblesemaphore/semaphore:latest
    ports:
      - "3000:3000"
    environment:
      SEMAPHORE_DB_DIALECT: bolt
      SEMAPHORE_ADMIN: admin
      SEMAPHORE_ADMIN_NAME: admin
      SEMAPHORE_ADMIN_EMAIL: admin@example.com
      SEMAPHORE_ADMIN_PASSWORD: 123456
    volumes:
      - semaphore_data:/var/lib/semaphore

volumes:
  semaphore_data:
```
```
docker compose up -d
```
