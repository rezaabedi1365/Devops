# Semaphore UI

### snap 
:x: limited for CLI Command
```
sudo apt update
sudo apt install snapd -y
```
```
sudo snap install semaphore --classic
```
```
sudo snap start semaphore
sudo snap stop semaphore
sudo snap remove semaphore
```

```
semaphore setup
```
```
semaphore server
```
http://localhost:3000

- these command not work in snap install
```
semaphore user list
semaphore user add --admin --login admin --name admin --email user123@example.com --password 2TDtvxRVYU
#change password
semaphore user change-by-login --login admin --password OTBtMIxc4q
```


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
