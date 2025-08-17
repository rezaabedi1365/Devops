
## pipeline
- stage
- job


```
stages:
  - build
  - test
  - deploy

build_job:
  stage: build
  image: python:3.11
  script:
    - echo "Building the project..."
    - pip install -r requirements.txt

test_job:
  stage: test
  image: python:3.11
  script:
    - echo "Running tests..."
    - pytest tests/

deploy_job:
  stage: deploy
  image: alpine
  script:
    - echo "Deploying the application..."

```

- Commit Condition
```
stages:
  - deploy

deploy_nginx:
  stage: deploy
  script:
    - echo "Deploying..."
  rules:
    - if: '$CI_COMMIT_MESSAGE =~ /deploy/'
      when: always
    - when: never

```

- runner tag
```
stages:
  - deploy

deploy_nginx:
  stage: deploy
  tags:
    - kubernetes  # تگ رانر که موقع ثبت رانر دادی
  script:
    - kubectl apply -f k8s/nginx-nodeport.yaml

```
