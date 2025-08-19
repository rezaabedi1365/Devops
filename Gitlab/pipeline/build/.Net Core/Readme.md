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
- simple .netcore7
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
- advance .netcore8 for visual studio
```
# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081


# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["DotNetSample/DotNetSample.csproj", "DotNetSample/"]
RUN dotnet restore "./DotNetSample/DotNetSample.csproj"
COPY . .
WORKDIR "/src/DotNetSample"
RUN dotnet build "./DotNetSample.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./DotNetSample.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetSample.dll"]
```
#### method 2-1): With Shell executer

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

#### metod 2-2): with docker executer
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
