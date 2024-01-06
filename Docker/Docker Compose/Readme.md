
# Docker Compose Cheat-sheet
https://www.baeldung.com/ops/docker-compose


Run Comose file
```
docker compose up -d
docker compose down
```
```
docker compose start
docker compose stop
docker compose pause
docker compose unpause
```
```
docker compose ps
docker compose up
```
```
version: '2'

services:
  web:

#Building
    # build from Dockerfile
    build: .

    # build from custom Dockerfile
    build:
    context: ./dir
    dockerfile: Dockerfile.dev

    # build from image
    image: ubuntu

#Ports
    ports:
     - "5000:5000"
    # expose ports to linked services (not to host)
       expose: ["3000"]

#Environment variables
    # environment vars
    environment:
    RACK_ENV: development
    environment:
     - RACK_ENV=development

    # environment vars from file
    env_file: .env
    env_file: [.env, .development.env]

    # make sure `db` is alive before starting
    depends_on:
      - db

#Network
    # creates a custom network called `frontend`
    networks:
      frontend:

    #External network
    # join a preexisting network
    networks:
      default:
        external:
          name: frontend

#Volumes
    volumes:
       - /var/lib/mysql
       - ./_data:/var/lib/mysql

#Commands
    # command to execute
    command: bundle exec thin -p 3000
    command: [bundle, exec, thin, -p, 3000]

    # override the entrypoint
    entrypoint: /app/start.sh
    entrypoint: [php, -d, vendor/bin/phpunit]

#Dependencies
    # makes the `db` service available as the hostname `database`
    # (implies depends_on)
    links:
      - db:database
      - redis
```
