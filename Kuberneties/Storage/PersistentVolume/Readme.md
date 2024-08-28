
# PersistentVolume & PersistentVolumeClaim
- capacity.storage
- columeMode
    * Filesystem
    * Block
- accessModes
   * ReadWriteOnce
   * ReadWriteMany
   * ReadOnlyMany
- persistentVolumeReclaimPolicy
     * Retain
     * Delete
- StorageClassName
     * slow
- mountOptions
  
# PersistentVolume
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfsserver
spec:
  capacity:
    storage: 1Mi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 10.10.12.10
    path: /share
    
```
------------------------------------------------------------------------------------------------------
# PersistentVolumeClaim
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-sc-example
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: slow
  selector:
    matchLabels:
      type: hostpath
```
------------------------------------------------------------------------------------------------------

![image](https://github.com/user-attachments/assets/213e1730-f820-4dd1-88fe-3c73d2704369)











--------------------------------------------------------------------------------------------------------
![image](https://github.com/user-attachments/assets/0af745eb-d9da-4dde-819c-c60f4cad4468)









