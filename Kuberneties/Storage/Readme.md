https://kubernetes.io/docs/concepts/storage/volumes/

* local storage
 - hostpath
 - Ephemeral [temporady]

* Remote storage
  - [Persistent Volumes]
     + NFS
     + CephFS
     + Ceph-RBD
     + GlusterFS

--------------------------------------------------------------------------
* Volumes
  - volumes  ( per Pod)
  - volumeMounts (per Container)
* Persistent Volumes
  - CANNOT
  - 
* Persistent VolumeClaims
* StorageClesses
  

---------------------------------------------------------------------------
 ## Volume Type

 ![image](https://github.com/user-attachments/assets/b415c151-2bfe-4456-9cce-aa634a5595c3)
 
Verify:
```
kubectl exex -it volume-example nginx --bash
kubectl exex -it volume-example nginx --sh
```
