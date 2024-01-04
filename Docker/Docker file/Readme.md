
# Dockerfile Cheat-sheet


```
FROM ruby:2.2.2

WORKDIR /myapp

ADD file.xyz /file.xyz
COPY --chown=user:group host_file.xyz /path/container_file.xyz

EXPOSE 5900

VOLUME ["/data"]

CMD    ["bundle", "exec", "rails", "server"]

```

