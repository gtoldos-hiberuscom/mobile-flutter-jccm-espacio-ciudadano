docker buildx build \
  --progress=plain \
  --load \
  -t jccm-espacio-ciudadano/flutter-android-ci:3.41.7-pipeline \
  gitlab-ci/docker/flutter-android




docker rm -f jccm-jenkins-pipeline-test 2>/dev/null || true
docker volume rm jccm-jenkins-home-pipeline-test 2>/dev/null || true

docker run -d \
  --name jccm-jenkins-pipeline-test \
  -p 8080:8080 \
  -v jccm-jenkins-home-pipeline-test:/var/lib/jenkins \
  -v "$HOME/.ssh/jenkins_bitbucket_ci_ed25519:/run/secrets/bitbucket_ssh_key:ro" \
  -e JENKINS_ADMIN_USER=admin \
  -e JENKINS_ADMIN_PASSWORD=admin \
  -e JENKINS_PIPELINE_REPO_URL=git@bitbucket.org:hiberus/mobile-flutter-jccm-espacio-ciudadano.git \
  -e JENKINS_PIPELINE_BRANCH=feature/cidcd \              
  -e JENKINS_GIT_SSH_PRIVATE_KEY_FILE=/run/secrets/bitbucket_ssh_key \
  -e JENKINS_GIT_SSH_PASSPHRASE='Arcani333!' \
  -e JENKINS_GIT_KNOWN_HOSTS="$(ssh-keyscan bitbucket.org 2>/dev/null)" \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7-pipeline


  docker run -d \
  --name jccm-jenkins-pipeline-test \
  -p 8080:8080 \
  -v jccm-jenkins-home-pipeline-test:/var/lib/jenkins \
  -v "$HOME/.ssh/jenkins_bitbucket_ci_ed25519:/run/secrets/bitbucket_ssh_key:ro" \
  -e JENKINS_ADMIN_USER=admin \
  -e JENKINS_ADMIN_PASSWORD=admin \
  -e JENKINS_PIPELINE_REPO_URL=git@bitbucket.org:hiberus/mobile-flutter-jccm-espacio-ciudadano.git \
  -e JENKINS_PIPELINE_BRANCH=feature/STORY-54-LifeEvents \
  -e JENKINS_GIT_SSH_PRIVATE_KEY_FILE=/run/secrets/bitbucket_ssh_key \
  -e JENKINS_GIT_SSH_PASSPHRASE='Arcani333!' \
  -e JENKINS_GIT_KNOWN_HOSTS="$(ssh-keyscan bitbucket.org 2>/dev/null)" \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7-pipeline








  docker rm -f jccm-jenkins-pipeline-test 2>/dev/null || true
docker volume rm jccm-jenkins-home-pipeline-test 2>/dev/null || true

docker run -d \
  --name jccm-jenkins-pipeline-test \
  -p 8080:8080 \
  -v jccm-jenkins-home-pipeline-test:/var/lib/jenkins \
  -v "$HOME/.ssh/jenkins_bitbucket_ci_ed25519:/run/secrets/bitbucket_ssh_key:ro" \
  -e JENKINS_ADMIN_USER=admin \
  -e JENKINS_ADMIN_PASSWORD=admin \
  -e JENKINS_PIPELINE_REPO_URL=git@bitbucket.org:hiberus/mobile-flutter-jccm-espacio-ciudadano.git \
  -e JENKINS_PIPELINE_BRANCH=feature/cicd \
  -e JENKINS_GIT_SSH_PRIVATE_KEY_FILE=/run/secrets/bitbucket_ssh_key \
  -e JENKINS_GIT_SSH_PASSPHRASE='Arcani333!' \
  -e JENKINS_GIT_KNOWN_HOSTS="$(ssh-keyscan bitbucket.org 2>/dev/null)" \
  -e JENKINS_JOB_REPO_URL=git@bitbucket.org:hiberus/mobile-flutter-jccm-espacio-ciudadano.git \
  -e JENKINS_JOB_BRANCH=feature/cicd \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7-pipeline