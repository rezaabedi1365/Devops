
### With Shell executer

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
      echo "COMMIT_MESSAGE : $CI_COMMIT_MESSAGE"
      cd "$CI_PROJECT_DIR/myproject"
      docker build -t myapp:$CI_COMMIT_SHORT_SHA -f "Dockerfile" .
      cd "$CI_PROJECT_DIR"
      docker run --rm myapp:$CI_COMMIT_SHORT_SHA
  artifacts:
    paths:
      - bin/
      - obj/

```

### with docker executer
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
  artifacts:
    paths:
      - bin/
      - obj/
    expire_in: 1 week

```
