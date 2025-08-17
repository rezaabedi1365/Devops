# crictl
- crictl is a command for CRI .CRI is a layer/interface between container runtimes and kubelet.
- CRI supports these container runtimes:
    * containerd
    * CRI-O
    * Mirantis Container Runtime
    * Kata Containers
## Containerd have seperate command to 
- ctr


---

### 📊 Docker ↔ crictl (CRI[containerd] / CRI-O)

| Docker CLI                              | معادل در `crictl`                     | توضیح / نکته Runtime                                                                                                                           |
| --------------------------------------- | ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `docker pull nginx:latest`              | `crictl pull nginx:latest`            | کشیدن ایمیج؛ endpoint پیش‌فرض به runtime وصل می‌شه: <br>• containerd: `/run/containerd/containerd.sock` <br>• CRI-O: `/var/run/crio/crio.sock` |
| `docker images`                         | `crictl images`                       | لیست همه ایمیج‌ها                                                                                                                              |
| `docker rmi nginx:latest`               | `crictl rmi nginx:latest`             | حذف ایمیج                                                                                                                                      |
| `docker ps`                             | `crictl ps`                           | لیست کانتینرهای در حال اجرا                                                                                                                    |
| `docker ps -a`                          | `crictl ps -a`                        | لیست همه کانتینرها، حتی استاپ‌شده‌ها                                                                                                           |
| `docker stop <id>`                      | `crictl stop <container-id>`          | توقف کانتینر                                                                                                                                   |
| `docker rm <id>`                        | `crictl rm <container-id>`            | حذف کانتینر                                                                                                                                    |
| `docker exec -it <id> bash`             | `crictl exec -it <container-id> bash` | ورود به کانتینر                                                                                                                                |
| `docker logs <id>`                      | `crictl logs <container-id>`          | نمایش لاگ‌ها                                                                                                                                   |
| `docker inspect <id>`                   | `crictl inspect <container-id>`       | جزئیات کانتینر                                                                                                                                 |
| `docker run -d --name web nginx:latest` | ❌ مستقیماً نداره                      | crictl برای run مستقیم کانتینر ساخته نشده؛ K8s کانتینرها رو مدیریت می‌کنه                                                                      |
| `docker info`                           | `crictl info`                         | نمایش اطلاعات runtime                                                                                                                          |
| `docker version`                        | `crictl version`                      | نسخه runtime و crictl                                                                                                                          |

---



---

# 📑 `crictl` Cheat Sheet

---

```
crictl pull nginx:latest
crictl --runtime-endpoint unix:///run/containerd/containerd.sock pull docker.io/library/<ImageName:Version>
crictl --runtime-endpoint unix:///run/containerd/containerd.sock pull docker.io/library/nginx:latest

crictl images

crictl rmi nginx:latest
crictl --runtime-endpoint unix:///run/containerd/containerd.sock rmi docker.io/library/nginx
```

---


```bash
crictl ps

crictl ps -a

crictl stop <container-id>

crictl rm <container-id>

crictl exec -it <container-id> bash
```

---


```bash
crictl pods

crictl stopp <pod-id>

crictl rmp <pod-id>
```

---



```bash

crictl logs <container-id>


crictl inspect <container-id>


crictl inspectp <pod-id>
```

---


```bash
crictl version

crictl info

crictl events

crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps
```
# some command not in cri and only have in containerd
<img width="688" height="270" alt="image" src="https://github.com/user-attachments/assets/428574d7-805f-4580-98d4-e63d63331b4c" />

```
docker save -o nginx.tar nginx:latest
ctr -n k8s.io images export nginx.tar docker.io/library/nginx:latest

docker load -i nginx.tar
ctr -n k8s.io images import nginx.tar

docker import container.tar newimage:tag
ctr -n k8s.io images import container.tar

docker export <container_id> -o container.tar
*****
```



