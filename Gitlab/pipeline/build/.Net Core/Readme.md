
```
stages:
  - build

build_job:
  stage: build
  image: mcr.microsoft.com/dotnet/sdk:7.0
  script:
    - echo "Building .NET Core project..."
    - dotnet restore            # بازیابی بسته‌ها (NuGet packages)
    - dotnet build --configuration Release   # بیلد پروژه در حالت Release
  artifacts:
    paths:
      - bin/
      - obj/

```
