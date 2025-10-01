# Postgres
- plain text Backup
  + .sql
  + Backup with pg_dump & pg_dumpall
  + Restore with psql
  + 
- Binary Backup
  + .backup or .dump
  + Backup with -FC
  + Restore with pgAdmin


### Method1: plain text Backup (OK)
list of database
```
docker exec -it postgres-ctr psql -U namadu -c "\l"
```
pg_dump Backup
```
docker exec -t my_postgres \
  pg_dump -U postgres mydb > mydb_backup.sql
```

Restore
```
cat mydb_backup.sql | docker exec -i my_postgres psql -U postgres -d mydb
```
verify:
```
docker exec -it fpaydb-container psql -U postgres -d test -c "\dt"
```

##### mount smb
mount
- 445&139 use port
```
sudo apt install cifs-utils -y
mkdir -p /mnt/smb_share
```
- nano /root/.smbcredentials
```
username=backupdb
password=123456@
```
```
sudo mount -t cifs //192.168.1.10/backupdb/verification-db /mnt/smb_share -o credentials=/root/.smbcredentials,vers=3.0
```
----------------------------------------------
###### send directly
```
docker exec -t my_postgres pg_dump -U postgres mydb > /mnt/smb_share/mydb_backup.sql
```
###### send file
```
sudo cp ./mydb_backup.sql /mnt/smb_share/
```

###### sctipt
```
#!/bin/bash

# تنظیمات
BACKUP_DIR="/mnt/smb_share"        # مسیر SMB mount شده
DB_CONTAINER="my_postgres"         # نام کانتینر PostgreSQL
DB_NAME="mydb"                     # نام دیتابیس
DB_USER="postgres"                 # یوزر دیتابیس

# حذف فایل‌های قدیمی‌تر از 7 روز
echo "حذف فایل‌های قدیمی‌تر از 7 روز در $BACKUP_DIR ..."
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +7 -exec rm -f {} \;

# گرفتن بکاپ با نام شامل تاریخ
DATE=$(date +%F)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$DATE.sql"
echo "در حال گرفتن بکاپ دیتابیس $DB_NAME ..."
docker exec -t $DB_CONTAINER pg_dump -U $DB_USER $DB_NAME > "$BACKUP_FILE"

echo "بکاپ در $BACKUP_FILE ذخیره شد."

```

--------------------------------------------------------------------------------------------------------------------------------------------------------
##### pg_dumpall Backup (Not OK)
```
docker exec -t my_postgres \
  pg_dumpall -U postgres > alldb_backup.sql
```
Restore
```
cat alldb_backup.sql | docker exec -i my_postgres psql -U postgres
```

### Method2: Binary Backup

list of database
```
docker exec -it postgres-ctr psql -U namadu -c "\l"
```
```
docker exec -t my_postgres pg_dump -U namadu -F c -d mydb > ./mydb_custom.backup
exec -t fpaydb-container pg_dump -U postgres -F c -d ApplicationManagment > ./mydb_custom.backup
```
restore
```
docker exec -i fpaydb-container \
  pg_restore -U postgres -d test < ./mydb_custom.backup
```
verify
```
docker exec -it fpaydb-container psql -U postgres -d test -c "\dt"
```







### sample: plain text Backup
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
