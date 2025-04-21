- https://www.youtube.com/watch?v=mKtyhrvZVrw
- https://www.youtube.com/watch?v=1J8u24lAriE
- https://docs.docker.com/engine/security/rootless/

# To install Docker in rootless mode on Ubuntu, follow these steps:

```
sudo apt update
sudo apt install uidmap dbus-user-session fuse-overlayfs slirp4netns
```

Verify subordinate UIDs/GIDs:
```
cat /etc/subuid
cat /etc/subgid
```
```
grep ^$(whoami): /etc/subuid
grep ^$(whoami): /etc/subgid
```

If Docker is already installed: Disable the system-wide daemon:

```
sudo systemctl disable --now docker.service docker.socket
sudo rm /var/run/docker.sock
```

### Install Rootless Docker
```
curl -fsSL https://get.docker.com/rootless | sh
```

### Set environment variables:
```
export PATH=/home/$USER/bin:$PATH
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
```
Apply the changes:
```
source ~/.bashrc
```

### Start Docker in rootless mode:
```
systemctl --user start docker
systemctl --user enable docker
```
### Verify Installation :

```
docker run hello-world
```
```
docker info
```
# When running Docker in rootless mode, binding to ports below 1024 (like 80 or 443) is restricted for security reasons.

Solution : Adjust ip_unprivileged_port_start (Recommended)
- Lower the minimum port number requiring root privileges system-wide
```
# Temporarily set for the current session
sudo sysctl -w net.ipv4.ip_unprivileged_port_start=80

# Make it permanent
echo "net.ipv4.ip_unprivileged_port_start=80" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```
After sysctl changes, restart the rootless Docker service:
```
systemctl --user restart docker
```
```
docker compose down --remove-orphans
docker compose up -d --force-recreate
```
