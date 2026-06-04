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
ARG JENKINS_DEFAULT_REPO_URL=git@github.com:gtoldos-hiberuscom/mobile-flutter-jccm-espacio-ciudadano.git
ARG JENKINS_DEFAULT_REPO_BRANCH=main
ARG JENKINS_HTTP_PORT=8080

LABEL org.opencontainers.image.title="JCCM Espacio Ciudadano Flutter Android CI" \
      org.opencontainers.image.description="Linux CI image for Flutter Android jobs with Jenkins" \
      org.opencontainers.image.source="gitlab-ci/docker/flutter-android" \
      org.opencontainers.image.version="${FLUTTER_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    FLUTTER_HOME=/opt/flutter \
    FLUTTER_ROOT=/opt/flutter \
    FLUTTER_SUPPRESS_ANALYTICS=true \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-${IMAGE_ARCH} \
    JENKINS_JAVA_HOME=/usr/lib/jvm/java-21-openjdk-${IMAGE_ARCH} \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

ENV JENKINS_HOME=/var/lib/jenkins \
    JENKINS_REF=/usr/share/jenkins/ref \
    HOME=/var/lib/jenkins \
    PUB_CACHE=/var/lib/jenkins/.pub-cache \
    GRADLE_USER_HOME=/var/lib/jenkins/.gradle \
    JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
    JENKINS_HTTP_PORT="${JENKINS_HTTP_PORT}" \
    JENKINS_JOB_REPO_URL="${JENKINS_DEFAULT_REPO_URL}" \
    JENKINS_JOB_BRANCH="${JENKINS_DEFAULT_REPO_BRANCH}" \
    JENKINS_JOB_COMMAND="flutter pub get && flutter test" \
    JENKINS_GIT_DEPTH=1

ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PUB_CACHE}/bin:${PATH}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      bash \
      build-essential \
      ca-certificates \
      curl \
      file \
      fontconfig \
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
      openjdk-21-jre-headless \
      openssh-client \
      ruby-full \
      tini \
      unzip \
      util-linux \
      xz-utils \
      zip \
    && rm -rf /var/lib/apt/lists/*

RUN install -d -m 0755 /etc/apt/keyrings \
    && curl -fsSL -o /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
    && echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends jenkins \
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
COPY jenkins-entrypoint.sh /usr/local/bin/jenkins-entrypoint
COPY jenkins/01-basic-security.groovy "${JENKINS_REF}/init.groovy.d/01-basic-security.groovy"
COPY jenkins/flutter-repo-job.xml "${JENKINS_REF}/jobs/flutter-repo-job/config.xml"
RUN chmod +x /usr/local/bin/ci-image-doctor /usr/local/bin/jenkins-entrypoint \
    && install -d -o jenkins -g jenkins "${JENKINS_HOME}" "${JENKINS_REF}" /workspace "${PUB_CACHE}" "${GRADLE_USER_HOME}" \
    && chown -R jenkins:jenkins "${JENKINS_HOME}" "${JENKINS_REF}" /workspace "${PUB_CACHE}" "${GRADLE_USER_HOME}" "${FLUTTER_HOME}" "${ANDROID_HOME}"

WORKDIR /workspace

EXPOSE 8080 50000
VOLUME ["/var/lib/jenkins"]

CMD ["tini", "--", "runuser", "--preserve-environment", "-u", "jenkins", "--", "/usr/local/bin/jenkins-entrypoint", "jenkins"]
