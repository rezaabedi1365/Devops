
Dockerfile
```
FROM ubuntu:22.04

# نصب ابزارهای لازم
RUN apt-get update && apt-get install -y \
    curl unzip git xz-utils zip openjdk-11-jdk wget libglu1-mesa

# نصب Android SDK
RUN mkdir -p /opt/android-sdk && cd /opt/android-sdk \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip \
    && unzip commandlinetools-linux-*.zip -d cmdline-tools \
    && rm commandlinetools-linux-*.zip

ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# قبول لایسنس‌ها
RUN yes | sdkmanager --licenses

# نصب Android platform tools و build-tools
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# نصب Flutter
RUN git clone https://github.com/flutter/flutter.git /opt/flutter
ENV PATH=/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:$PATH

# چک کردن نصب
RUN flutter doctor -v

```
gitlab-ci.yml
```
stages:
  - build

build_android:
  image: your-docker-image:latest
  stage: build
  script:
    - flutter pub get
    - flutter build apk --release
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk

```
