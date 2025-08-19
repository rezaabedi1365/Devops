

- in branch main pipline
```
stages:
  - build

build_job:
  stage: build
  image: docker-with-jq:1.0.0
  tags:
    - push-docker-build-local   # اجرای Job روی رانر با این تگ
  script:
    - |
      echo "CCOMMIT_TITLE : $CI_COMMIT_TITLE"
      cd "$CI_PROJECT_DIR/myproject"
      docker build -t $CI_COMMIT_TITLE -f "Dockerfile" .
      cd "$CI_PROJECT_DIR"
      docker run $CI_COMMIT_TITLE
  artifacts:
    paths:
      - bin/
      - obj/
```
