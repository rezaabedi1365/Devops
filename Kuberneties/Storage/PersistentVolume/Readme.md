
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
  

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfsserver
spec:
  capacity:
    storage: 50Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  PersistentVolumeReclaimPolicy: Delete
  storageClassName: slow
  mountOptions:
    - hard
    - nfservers=4.1
  nfs:
    path: /exports
    server: 172.22.0.42
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











-
![image](https://github.com/user-attachments/assets/0af745eb-d9da-4dde-819c-c60f4cad4468)









