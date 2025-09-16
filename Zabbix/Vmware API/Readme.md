#### Edit Zabbix config file in docker container
```
docker cp CONTAINER:/etc/zabbix/zabbix_server_vmware.conf .
```
umcomment this line 
```
StartVMwareCollectors=5
```
```
docker cp zabbix_server_vmware.conf CONTAINER:/etc/zabbix/zabbix_server_vmware.conf 
```

### 
```
docker restart CONTAINER
```

### Verify on host
```
ps aux | grep vmware
```
<img width="1037" height="181" alt="image" src="https://github.com/user-attachments/assets/c11d8a6c-2b24-48b5-ba78-97146b44823e" />
