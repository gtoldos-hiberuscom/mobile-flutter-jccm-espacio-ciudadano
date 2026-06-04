pipeline {
  agent any

  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '20'))
    skipDefaultCheckout(true)
  }

  parameters {
    choice(
      name: 'BUILD_TARGET',
      choices: ['appbundle', 'apk'],
      description: 'Android artifact to build'
    )
    string(x
      name: 'DART_DEFINE_FILE',
      defaultValue: 'config_production.json',
      description: 'Path to the dart-define JSON file'
    )
    booleanParam(
      name: 'RUN_TESTS',
      defaultValue: false,
      description: 'Run flutter test before the Android build'
    )
    booleanParam(
      name: 'CLEAN_BEFORE_BUILD',
      defaultValue: false,
      description: 'Run flutter clean before building'
    )
  }

  environment {
    CI = 'true'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Prepare') {
      steps {
        sh '''#!/usr/bin/env bash
set -euo pipefail

if [[ -f android/gradle.properties ]]; then
  gradle_properties=android/gradle.properties

  upsert_gradle_property() {
    local name="$1"
    local value="$2"
    if grep -q "^${name}=" "${gradle_properties}"; then
      sed -i "s|^${name}=.*|${name}=${value}|" "${gradle_properties}"
    else
      printf '%s=%s\\n' "${name}" "${value}" >> "${gradle_properties}"
    fi
  }

  upsert_gradle_property "org.gradle.jvmargs" "-Xmx2G -XX:MaxMetaspaceSize=1G -XX:ReservedCodeCacheSize=256m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8"
  upsert_gradle_property "org.gradle.daemon" "false"
  upsert_gradle_property "org.gradle.vfs.watch" "false"
  upsert_gradle_property "org.gradle.workers.max" "2"
  upsert_gradle_property "org.gradle.parallel" "false"
  upsert_gradle_property "kotlin.daemon.jvmargs" "-Xmx1024m"
fi
'''
      }
    }

    stage('Dependencies') {
      steps {
        sh 'flutter --version'
        sh 'flutter pub get'
      }
    }

    stage('Tests') {
      when {
        expression { params.RUN_TESTS }
      }
      steps {
        sh 'flutter test'
      }
    }

    stage('Build Android') {
      steps {
        script {
          if (params.CLEAN_BEFORE_BUILD) {
            sh 'flutter clean'
            sh 'flutter pub get'
          }

          def buildCommand = params.BUILD_TARGET == 'apk'
            ? "flutter build apk --release --dart-define-from-file=${params.DART_DEFINE_FILE}"
            : "flutter build appbundle --release --dart-define-from-file=${params.DART_DEFINE_FILE}"

          sh buildCommand
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'build/app/outputs/**/*.aab,build/app/outputs/**/*.apk', allowEmptyArchive: true, fingerprint: true
    }
  }
}
