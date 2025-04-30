### Create docker file
```
nano Dockerfile
```
change image file with chown 
```
FROM postgres:14.4-alpine
RUN chown -R postgres:postgres /var/lib/postgresql /var/run/postgresql
USER postgres
RUN id
```

### Create Docker compose
```
mkdir -p /opt/services/postgres/pgdata
mkdir -p /opt/services/postgres/run
```
create docker-compose.yml
- step1 : first one time run docker compose without user parametr in file ( in this step created volume and insert root uid as owner volume directory path
```
docker exec -it postgresql-rootless-postgres-1 id
docker exec -it postgresql-rootless-postgres-1 ps
```

- step2 : run container with docker run command and get postgre uid
```
docker run -v ./postgres_data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=secret -e PGDATA=/var/lib/postgresql/data/ -e POSTGRES_DB=namad -e POSTGRES_USER=namadu postgres:14.4-alpine
```
- step3: now set rootles user in host and postgress user in container as same
```
```
usermod -g 70 -u 70 namad
```
- step4:
```

services:
  db:
    build: .
    restart: always
    environment:
      POSTGRES_USER: postgres-db
      POSTGRES_PASSWORD: Aa123456
      POSTGRES_DB: namad
      PGDATA: /var/lib/postgresql/data/pgdata
    user: "70:70" #default user 
    ports:
      - 5432:5432
    volumes:
      - "./pgdata:/var/lib/postgresql/data"
      - "./run:/var/run/postgresql"
```

### verify
use DBeaver application to connect to database
- https://soft98.ir/software/programming/2962-dbeaver.html
```
docker ps
ss -tunlp | grep postgres
```
