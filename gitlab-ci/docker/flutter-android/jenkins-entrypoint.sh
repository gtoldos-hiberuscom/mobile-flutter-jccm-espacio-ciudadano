#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-jenkins}" != "jenkins" ]]; then
  exec "$@"
fi

: "${JENKINS_HOME:=/var/lib/jenkins}"
: "${JENKINS_REF:=/usr/share/jenkins/ref}"
: "${JENKINS_HTTP_PORT:=8080}"
: "${JAVA_OPTS:=-Djenkins.install.runSetupWizard=false}"

mkdir -p "${JENKINS_HOME}"

if [[ -d "${JENKINS_REF}" ]]; then
  while IFS= read -r -d '' ref_file; do
    relative_path="${ref_file#${JENKINS_REF}/}"
    target_file="${JENKINS_HOME}/${relative_path}"

    if [[ ! -e "${target_file}" ]]; then
      mkdir -p "$(dirname "${target_file}")"
      cp -a "${ref_file}" "${target_file}"
    fi
  done < <(find "${JENKINS_REF}" -type f -print0)
fi

jenkins_war="${JENKINS_WAR:-/usr/share/java/jenkins.war}"
if [[ ! -f "${jenkins_war}" && -f /usr/share/jenkins/jenkins.war ]]; then
  jenkins_war=/usr/share/jenkins/jenkins.war
fi

java_opts=()
if [[ -n "${JAVA_OPTS:-}" ]]; then
  read -r -a java_opts <<< "${JAVA_OPTS}"
fi

jenkins_opts=()
if [[ -n "${JENKINS_OPTS:-}" ]]; then
  read -r -a jenkins_opts <<< "${JENKINS_OPTS}"
fi

java_bin=java
if [[ -n "${JENKINS_JAVA_HOME:-}" && -x "${JENKINS_JAVA_HOME}/bin/java" ]]; then
  java_bin="${JENKINS_JAVA_HOME}/bin/java"
fi

cd "${JENKINS_HOME}"
exec "${java_bin}" "${java_opts[@]}" -jar "${jenkins_war}" --httpPort="${JENKINS_HTTP_PORT}" "${jenkins_opts[@]}"
