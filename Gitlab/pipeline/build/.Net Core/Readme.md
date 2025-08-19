# Build
- step1: application build
- step2: image build
### Method 1
- build application in pipeline
- build image in pipeline
    * push image to local registry
    * pull image in cluster
    * run pod in cluster or run container in docker

### Method 2
- build application in pipeline
- build image in pipeline
    * push image to local registry
    * pull image in cluster
    * run pod in cluster or run container in docker

# bulid applicatin pipeline
```
stages:
  - build

build_job:
  stage: build
  image: mcr.microsoft.com/dotnet/sdk:7.0
  tags:
    - push-docker-build-local   # اجرای Job روی رانر با این تگ
  script:
    - echo "Building .NET Core project..."
    - dotnet restore            # بازیابی بسته‌ها (NuGet packages)
    - dotnet build --configuration Release   # بیلد پروژه در حالت Release
  artifacts:
    paths:
      - bin/
      - obj/

```
