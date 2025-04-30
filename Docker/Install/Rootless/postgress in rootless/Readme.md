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
https://soft98.ir/software/programming/2962-dbeaver.html
```
docker ps
ss -tunlp | grep postgres
```
