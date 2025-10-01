

# Postgres
- plain text Backup
  + .sql
  + Backup with pg_dump & pg_dumpall
  + Restore with psql
  + 
- Binary Backup
  + .backup or .dump
  + Backup with -FC 


### Method1: pg_dump Backup
```
docker exec -t my_postgres \
  pg_dump -U postgres mydb > mydb_backup.sql
```

Restore
```
cat mydb_backup.sql | docker exec -i my_postgres psql -U postgres -d mydb
```

### Method2: pg_dumpall Backup
```
docker exec -t my_postgres \
  pg_dumpall -U postgres > alldb_backup.sql
```
Restore
```
cat alldb_backup.sql | docker exec -i my_postgres psql -U postgres
```
### sample
compose environment
```
ervices:
  postgres:
    image: postgres:14.4-alpine
    container_name: postgres
    environment:
      POSTGRES_USER: namadu
      POSTGRES_PASSWORD: 123456789
      POSTGRES_DB: namadb
      PGDATA: /var/lib/postgresql/data/pgdata
    ports:
      - "5432:5432"
    restart: unless-stopped
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
```
pg_dump
```
docker exec -t my_postgres \
  pg_dump -U namadu namadb > ./namadb_backup.sql
```
Restore
```
cat alldb_backup.sql | docker exec -i my_postgres psql -U namadu
```

pg_dumpall
```
docker exec -t my_postgres \
  pg_dumpall -U namadu > alldb_backup.sql
```
Restore
```
cat namadb_backup.sql | docker exec -i my_postgres psql -U namadu -d namadb
```
