

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
