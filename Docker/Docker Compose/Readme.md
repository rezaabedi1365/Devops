
# Docker Compose Cheat-sheet
https://www.baeldung.com/ops/docker-compose


Run Comose file
```
docker-compose up -d
docker-compose down
```
```
docker-compose start
docker-compose stop
docker-compose pause
docker-compose unpause
```
```
docker-compose ps
docker-compose up
```
```
# docker-compose.yml
web:
  # build from Dockerfile
  build: .

  # build from custom Dockerfile
  build:
    context: ./dir
    dockerfile: Dockerfile.dev

  # build from image
  image: ubuntu

    ports:
     - "5000:5000"
    volumes:
     - .:/code
  redis:
    image: redis
```
