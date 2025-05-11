# Method 1 (chat GPT)
## Running PostgreSQL with Docker Compose in Rootless Mode with root user

Running PostgreSQL in Docker Compose under rootless mode is both possible and increasingly common for enhanced security. Rootless Docker allows non-root users to run containers, reducing the risk of privilege escalation. Here’s how you can set up PostgreSQL in this environment, along with key considerations.

**1. Prerequisites**

- Docker installed and configured in rootless mode for your user.
- Docker Compose installed and accessible to your user.
- Proper permissions on host directories used as volumes, matching the container’s expected user and group IDs[2][4].

**2. Example `docker-compose.yml` for Rootless PostgreSQL**

Here’s a minimal example of a `docker-compose.yml` file suitable for rootless Docker:

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:16
    container_name: postgres
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=myuser
      - POSTGRES_PASSWORD=mypassword
      - POSTGRES_DB=mydb
    volumes:
      - ./postgres/data:/var/lib/postgresql/data
    restart: unless-stopped
```
- Adjust `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB` as needed.
- The `./postgres/data` directory should exist and be owned by your user to avoid permission issues[2][4][6].

**3. Directory Permissions**

Since rootless containers cannot write to directories owned by root, ensure the data directory is owned by your user. For example:

```sh
mkdir -p ./postgres/data
chown $(id -u):$(id -g) ./postgres/data
```
This prevents permission errors when PostgreSQL tries to initialize or write data[2][4].

**4. Running Docker Compose**

Start the service as your (non-root) user:

```sh
docker-compose up -d
```
**5. Notes and Troubleshooting**

- If you encounter permission errors, double-check volume ownership and permissions[2][4].
- If you need to run PostgreSQL as a non-root user inside the container, the official image already uses a non-root user (`postgres`) for the main process[1].
- For more complex setups (custom configs, multiple services), expand the `docker-compose.yml` accordingly[2][6].

**6. Advanced: Custom User IDs**

- If you need to match the container’s UID/GID with your host user (for shared volumes), you may need to adjust the user in the Dockerfile or use the `user:` directive in Compose, but for standard PostgreSQL images this is rarely necessary[1][5].


![image](https://github.com/user-attachments/assets/c10813c2-fe3c-4caa-9ad6-08713baa11c2)

**7. verify:**
```
docker ps
ss -tunlp | grep postgres
```
# Method 2 (khayat)
## Running PostgreSQL with Docker Compose in Rootless Mode with root user

**1. Create docker compose**
```
mkdir -p ./postgres_data
```
```
services:
  postgres-ownership:
    image: postgres:14.4-alpine
    volumes:
      - "./postgres_data:/take"
    entrypoint:
      - sh
      - -c
      - |
        chown -R 70:70 /take
  postgres:
    depends_on:
      postgres-ownership:
        condition: service_completed_successfully
    image: postgres:14.4-alpine
    container_name: postgres-rootless
    environment:
      POSTGRES_USER: namadu
      POSTGRES_PASSWORD: aA123456
      POSTGRES_DB: namadb
      PGDATA: /var/lib/postgresql/data/pgdata
    ports:
      - "5432:5432"
    user: "70"
    restart: unless-stopped
    volumes:
      - "./postgres_data:/var/lib/postgresql/data"
```


create docker-compose.yml
- step1 : first one time run docker compose without user parametr in file ( in this step created volume and insert root uid as owner volume directory path
```
docker exec -it postgresql-rootless-postgres-1 id
docker exec -it postgresql-rootless-postgres-1 ps
```

- step2 : run container with docker run command and get postgre uid
```
docker run -v ./postgres_data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=secret -e PGDATA=/var/lib/postgresql/data/ -e POSTGRES_DB=namad -e POSTGRES_USER=namadu postgres:14.4-alpine
```

- step3: now set rootles user in host and postgress user in container as same

```
#in container
docker exec -it postgresql-rootless-postgres-1 id

#in host change uid and gid rootless user (in this case namad)
usermod -g 70 -u 70 namad
```


### verify
use DBeaver application to connect to database
- https://soft98.ir/software/programming/2962-dbeaver.html
```
docker ps
ss -tunlp | grep postgres
```
