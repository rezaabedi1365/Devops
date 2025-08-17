# crictl
- crictl is a command for CRI .CRI is a layer/interface between container runtimes and kubelet.
- CRI supports these container runtimes:
    * containerd
    * CRI-O
    * Mirantis Container Runtime
    * Kata Containers

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


