
* local storage
* Remote storage
    - NFS
    - CephFS
    - Ceph-RBD
    - GlusterFS
---------------------------------------------------------------------------
## Ephemeral vs Persistent
* store Data temporary
* store Data permanently
--------------------------------------------------------------------------
* Volumes
  - volumes  ( per Pod)
  - volumeMounts (per Container)
* Persistent Volumes (  )
* Persistent VolumeClaims
* StorageClesses
  

---------------------------------------------------------------------------
 ## Volume Type

 ![image](https://github.com/user-attachments/assets/b415c151-2bfe-4456-9cce-aa634a5595c3)


apiVersion: v1
kind: Pod
metadata:
  name: configmap-pod
spec:
  containers:
    - name: test
      image: busybox:1.28
      command: ['sh', '-c', 'echo "The app is running!" && tail -f /dev/null']
      volumeMounts:
        - name: config-vol
          mountPath: /etc/config
  volumes:
    - name: config-vol
      configMap:
        name: log-config
        items:
          - key: log_level
            path: log_level
