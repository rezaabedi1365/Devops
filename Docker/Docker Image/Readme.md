# Senario
### export image
- on this host and migrate to other host
```
#host1
docker save postgres:14.4-alpine > mypostgres.tar
#host2
docker load -i mypostgres.tar
```
### export container
- on this host and migrate as a image to other host
```
#host1
docker export example-voting-app-db-1 > voting-db.tar
#host2
docker import voting-db.tar voting-db:test
```
### export volume
```
docker volume ls
```
- use temp container same ubuntu or alpine with tar package to export volume
```
docker run --rm -v <Volune_Name>:/volume -v $(pwd):/backup ubuntu tar cvf /backup/my_volume_backup.tar /volume
docker run --rm -v <Volune_Name>:/volume -v $(pwd):/backup alpine tar cvf /backup/my_volume_backup.tar /volume
```
- import
```
docker run --rm -v <Volune_Name>:/volume -v $(pwd):/backup ubuntu bash -c "cd /volume && tar xvf /backup/my_volume_backup.tar --strip 1"
```
------------------------------------------------------------------------------------------------

## Comparison Table

| Command           | Target      | Output Type             | Use Case                                      | How to Use                                  |
|-------------------|-------------|-------------------------|-----------------------------------------------|----------------------------------------------|
| docker save       | Image       | Image tarball           | Migrate, share, or backup a Docker image      | `docker save myimage:tag > myimage.tar`      |
| docker export     | Container   | Filesystem tarball      | Inspect, debug, or extract container contents | `docker export mycontainer > mycontainer.tar`|



| Command         | Target/Object      | What It Does                                      | What It Preserves         | Typical Use Case                              |
|-----------------|-------------------|---------------------------------------------------|--------------------------|------------------------------------------------|
| docker load     | Image             | Restores images from a tarball created by `save`   | All layers, metadata, tags, history | Restoring or migrating images                   |
| docker import   | Filesystem tarball| Creates a new image from a filesystem tarball      | Only the filesystem (no layers, metadata, history) | Creating a new image from a container export or any filesystem archive |


## Syntax 

```bash
docker save myimage:tag > myimage.tar
docker load -i myimage.tar
```


```bash
docker export mycontainer > mycontainer.tar
docker import mycontainer.tar mynewimage:tag
```




