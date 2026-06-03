ARG IMAGE_ARCH=amd64
FROM --platform=linux/${IMAGE_ARCH} ubuntu:24.04

ARG IMAGE_ARCH
ARG FLUTTER_VERSION=3.41.7
ARG ANDROID_COMMANDLINE_TOOLS_VERSION=14742923
ARG ANDROID_PLATFORM=android-36
ARG ANDROID_BUILD_TOOLS=36.0.0
ARG ANDROID_SYSTEM_IMAGE_API=android-36
ARG ANDROID_SYSTEM_IMAGE_VARIANT=google_apis
ARG ANDROID_SYSTEM_IMAGE_ARCH=x86_64
ARG INSTALL_ANDROID_SYSTEM_IMAGE=false
ARG FASTLANE_VERSION=2.234.0

LABEL org.opencontainers.image.title="JCCM Espacio Ciudadano Flutter Android CI" \
      org.opencontainers.image.description="Linux CI image for GitLab Flutter Android jobs" \
      org.opencontainers.image.source="gitlab-ci/docker/flutter-android" \
      org.opencontainers.image.version="${FLUTTER_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    FLUTTER_HOME=/opt/flutter \
    FLUTTER_ROOT=/opt/flutter \
    FLUTTER_SUPPRESS_ANALYTICS=true \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-${IMAGE_ARCH} \
    PUB_CACHE=/root/.pub-cache \
    GRADLE_USER_HOME=/root/.gradle \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PUB_CACHE}/bin:${PATH}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      bash \
      build-essential \
      ca-certificates \
      curl \
      file \
      git \
      jq \
      libasound2t64 \
      libdbus-1-3 \
      libfontconfig1 \
      libffi-dev \
      libglu1-mesa \
      libnss3 \
      libpulse0 \
      libssl-dev \
      libstdc++6 \
      libx11-6 \
      libxcomposite1 \
      libxcursor1 \
      libxdamage1 \
      libxfixes3 \
      libxi6 \
      libxkbcommon0 \
      libxrandr2 \
      libxrender1 \
      libxtst6 \
      openjdk-17-jdk \
      openssh-client \
      ruby-full \
      unzip \
      xz-utils \
      zip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p "${ANDROID_HOME}/cmdline-tools" \
    && curl -fsSL "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_COMMANDLINE_TOOLS_VERSION}_latest.zip" -o /tmp/android-commandline-tools.zip \
    && unzip -q /tmp/android-commandline-tools.zip -d "${ANDROID_HOME}/cmdline-tools" \
    && mv "${ANDROID_HOME}/cmdline-tools/cmdline-tools" "${ANDROID_HOME}/cmdline-tools/latest" \
    && rm /tmp/android-commandline-tools.zip

RUN (set +o pipefail; yes | sdkmanager --licenses >/dev/null)

RUN sdkmanager --install \
      "platform-tools" \
      "platforms;${ANDROID_PLATFORM}" \
      "build-tools;${ANDROID_BUILD_TOOLS}" \
      "emulator" \
    && if [[ "${INSTALL_ANDROID_SYSTEM_IMAGE}" == "true" ]]; then sdkmanager --install "system-images;${ANDROID_SYSTEM_IMAGE_API};${ANDROID_SYSTEM_IMAGE_VARIANT};${ANDROID_SYSTEM_IMAGE_ARCH}"; fi

RUN git clone --branch "${FLUTTER_VERSION}" --depth 1 https://github.com/flutter/flutter.git "${FLUTTER_HOME}" \
    && git config --system --add safe.directory '*' \
    && flutter config --no-analytics \
    && flutter config --android-sdk "${ANDROID_HOME}" \
    && flutter precache --android --universal \
    && flutter --version \
    && dart --version

RUN gem install bundler --no-document \
    && gem install fastlane -v "~> ${FASTLANE_VERSION}" --no-document

COPY ci-image-doctor.sh /usr/local/bin/ci-image-doctor
RUN chmod +x /usr/local/bin/ci-image-doctor

WORKDIR /workspace

CMD ["ci-image-doctor"]
