
# To install Docker in rootless mode on Ubuntu, follow these steps:
```
useradd -m docker1 -s /bin/bash -G sudoer
passwd docker1
```
login with spesfic user and instlal component

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

If Docker is already installed: Remove it:

```
apt remove --purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Install Rootless Docker
```
curl -fsSL https://get.docker.com/rootless | sh

```
install dockercompose
```
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod u+x ~/.docker/cli-plugins/docker-compose
```
### Set environment variables:
:x:
```
sudo loginctl enable-linger $(whoami)
```
```
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
echo 'export XDG_RUNTIME_DIR=/run/user/$(id -u)' >> ~/.bashrc
echo 'export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock' >> ~/.bashrc
echo 'export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"' >> ~/.bashrc
```
Apply the changes in bashrc:
```
source ~/.bashrc
```

### Start Docker in rootless mode:
```
systemctl --user daemon-reexec
systemctl --user daemon-reload

systemctl --user start docker
systemctl --user enable docker
systemctl --user status docker
```
### Verify Installation :

```
docker run hello-world
```

```
docker info
which docker
```
- /home/YOUR_USER/bin

### check dockerDeamon and container with which user to run 
check dockerDeamon with which user run
```
pstree -hp | grep docker
ps -aux | grep containerd
```

check container with which user run 
```
docker exec Container_NAME id
```

# Remove docker rootless
```
rm -f /home/$USER/bin/dockerd
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
if you have probleme in compose up use this command to up or down
```
docker compose down --remove-orphans
docker compose up -d --force-recreate
```



