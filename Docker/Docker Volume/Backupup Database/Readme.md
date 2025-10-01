
### SQLserver

```
docker exec -it sqlserver \
  /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "YourPassword123" \
  -Q "BACKUP DATABASE [MyDB] TO DISK = N'/var/opt/mssql/backup/MyDB.bak' WITH NOFORMAT, NOINIT, NAME = 'MyDB-Full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"
```
```
docker cp sqlserver:/var/opt/mssql/backup/MyDB.bak ./MyDB.bak
```
