# Build
- step1: application build
- step2: image build
## Method 1
- build application in pipeline
- build image in pipeline
    * push image to local registry
    * pull image in cluster
    * run pod in cluster or run container in docker


```
stages:
  - build
  - docker-build

# Job اول: بیلد پروژه‌ی دات‌نت
build_job:
  stage: build
  image: mcr.microsoft.com/dotnet/sdk:7.0
  tags:
    - push-docker-build-local
  script:
    - echo "Building .NET Core project..."
    - dotnet restore
    - dotnet build --configuration Release
  artifacts:
    paths:
      - bin/
      - obj/

# Job دوم: بیلد ایمیج Docker
docker_build_job:
  stage: docker-build
  image: docker:24.0.2
  services:
    - docker:24.0.2-dind
  variables:
    DOCKER_DRIVER: overlay2
    DOCKER_TLS_CERTDIR: ""
  tags:
    - push-docker-build-local
  script:
    - echo "Building Docker image for commit $CI_COMMIT_SHORT_SHA ..."
    - docker build -t myapp:$CI_COMMIT_SHORT_SHA -f Dockerfile .
    - docker images | grep myapp
  needs:
    - build_job
```
## Method 2
- build application in Dockerfile
- build image in pipeline
    * push image to local registry
    * pull image in cluster
    * run pod in cluster or run container in docker

#### ِDockerfile
```
# مرحله اول: Restore و Build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# کپی csproj و بازیابی پکیج‌ها (بهینه برای cache)
COPY *.sln .
COPY myproject/*.csproj ./myproject/
RUN dotnet restore

# کپی کل سورس‌کد و Build
COPY . .
WORKDIR /src/myproject
RUN dotnet build -c Release -o /app/build

# مرحله دوم: Publish
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

# مرحله نهایی: اجرای برنامه
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "myproject.dll"]

```
#### With Shell executer

- in branch main pipline
```
stages:
  - build

build_job:
  stage: build
  image: docker-with-jq:1.0.0
  tags:
    - push-docker-build-local
  script:
    - |
      echo "COMMIT_TITLE : $CI_COMMIT_TITLE"
      cd "$CI_PROJECT_DIR/myproject"
      docker build -t $CI_COMMIT_TITLE -f "Dockerfile" .
      cd "$CI_PROJECT_DIR"
      docker run $CI_COMMIT_TITLE
```

#### with docker executer
```
stages:
  - build

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""   # برای غیرفعال کردن TLS در DinD

build_docker:
  stage: build
  image: docker:24.0.2  # آخرین نسخه docker CLI
  services:
    - docker:24.0.2-dind
  tags:
    - push-docker-build-local
  before_script:
    - echo "Using Docker-in-Docker..."
    - docker info
  script:
    - cd "$CI_PROJECT_DIR/myproject"
    - echo "Building Docker image for commit $CI_COMMIT_SHORT_SHA"
    - docker build -t myapp:$CI_COMMIT_SHORT_SHA -f Dockerfile .
    - echo "Running Docker container..."
    - docker run --rm myapp:$CI_COMMIT_SHORT_SHA
      #can use docker compose . must be creafe docker-compose.yml 
  artifacts:
    paths:
      - bin/
      - obj/
    expire_in: 1 week

```
