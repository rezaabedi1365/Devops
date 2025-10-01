
# SQLserver
Backup
```
docker exec -it sqlserver \
  /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "YourPassword123" \
  -Q "BACKUP DATABASE [MyDB] TO DISK = N'/var/opt/mssql/backup/MyDB.bak' WITH NOFORMAT, NOINIT, NAME = 'MyDB-Full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"
```
```
docker cp sqlserver:/var/opt/mssql/backup/MyDB.bak ./MyDB.bak
```
Restore

# Postgres
pg_dump Backup
```
docker exec -t my_postgres \
  pg_dump -U postgres mydb > mydb_backup.sql
```

Restore
```
cat mydb_backup.sql | docker exec -i my_postgres psql -U postgres -d mydb
```

-------------
pg_dumpall Backup
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
environment:
  POSTGRES_USER: user1
  POSTGRES_PASSWORD: 123456
  POSTGRES_DB: database1
  PGDATA: /var/lib/postgresql/data/pgdata
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
