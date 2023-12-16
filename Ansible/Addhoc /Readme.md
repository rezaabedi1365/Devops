
# addhoc
- syntax :
  ```
  ansible [inventory] -m [Module] command
  ```
   * [shell](####rd)
   * [raw]()
   * [apt]()
   * [service]()
   * [setup]()


----------------------------------------------------------------
##### Module shell
```
ansible all –b –m shell –a "whoami"
```
##### Module raw
```
ansible all –m raw "echo hi > ~/test.txt" 
```
##### Module apt
```
ansible all –b -m apt –a "update_cache=yes name=apache2 state=latest"  
```
##### Module service
```
ansible all –m service –a "name=apache2 state=started enabled=yes
```
##### Module setup
```
ansible all –m setup
```


