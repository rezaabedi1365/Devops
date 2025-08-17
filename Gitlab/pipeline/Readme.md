
## pipeline
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
