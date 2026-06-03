#!/usr/bin/env bash
set -euo pipefail

echo "Flutter"
flutter --version

echo
echo "Dart"
dart --version

echo
echo "Java"
java -version

echo
echo "Android SDK"
sdkmanager --version
adb version

echo
echo "Fastlane"
fastlane --version

if [[ -x "./gradlew" ]]; then
  echo
  echo "Gradle wrapper"
  ./gradlew --version
fi

