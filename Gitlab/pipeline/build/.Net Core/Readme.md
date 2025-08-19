# Build
- step1: application build
- step2: image build
## Method 1
- build application in pipeline
- build image in pipeline
    * push image to local registry
    * pull image in cluster
    * run pod in cluster or run container in docker

#### bulid applicatin pipeline
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
## Method 2
- build application in Dockerfile
- build image in pipeline
    * push image to local registry
    * pull image in cluster
    * run pod in cluster or run container in docker


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

