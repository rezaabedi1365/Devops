```
project-root/
│── wordpress/
│   ├── docker-compose.yml
│   └── .env
└── caddy/
    ├── docker-compose.yml
    └── Caddyfile
 
```
# Caddy
/caddy/docker-compose.yml
```
version: "3.9"

services:
  caddy:
    image: caddy:2
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
    networks:
      - web

volumes:
  caddy_data:
  caddy_config:

networks:
  web:
    external: true

```

/caddy/Caddyfile
```
blog.titil.online {
    encode gzip
    reverse_proxy wordpress:80
}

app.titil.online {
    encode gzip
    reverse_proxy app:5000
}

```

# wordpress
/wordpress/docker-compose.yml
```
version: "3.9"

services:
  db:
    image: mysql:8.0
    command: --default-authentication-plugin=mysql_native_password
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      TZ: ${TZ}
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - web
    restart: unless-stopped

  wordpress:
    image: wordpress:php8.2-apache
    depends_on:
      - db
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_NAME: ${MYSQL_DATABASE}
      WORDPRESS_DB_USER: ${MYSQL_USER}
      WORDPRESS_DB_PASSWORD: ${MYSQL_PASSWORD}
      WORDPRESS_TABLE_PREFIX: ${WP_TABLE_PREFIX}
    volumes:
      - wp_data:/var/www/html
    networks:
      - web
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 5s
      retries: 5

volumes:
  db_data:
  wp_data:

networks:
  web:
    external: true

```
/wordpress/env
```
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
MYSQL_PASSWORD=your_password
WP_TABLE_PREFIX=wp_
TZ=UTC
```
