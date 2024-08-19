
# PersistentVolume
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
