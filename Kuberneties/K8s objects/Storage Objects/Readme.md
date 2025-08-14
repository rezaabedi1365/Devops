## Storage objects
  - PersistentVolume (PV)
  - PersistentVolumeClaim (PVC)
  - StorageClass

## Volumes
  - volumes  ( per Pod)
  - volumeMounts (per Container)
    
## VolumeType and DriverInterface
  - CSI
  - emptyDir
  - hostPath
------------------------------------------------------------------------
https://kubernetes.io/docs/concepts/storage/volumes/

### local storage
 - hostpath
 - Ephemeral [temporady]

### Remote storage
  * [Persistent Volumes]
     + NFS
     + Ceph
         - CephFS
         - Ceph-RBD
         - Ceph-s3
      + GlusterFS
      + MinIO



Verify:
```
kubectl exex -it volume-example nginx --bash
kubectl exex -it volume-example nginx --sh
```
