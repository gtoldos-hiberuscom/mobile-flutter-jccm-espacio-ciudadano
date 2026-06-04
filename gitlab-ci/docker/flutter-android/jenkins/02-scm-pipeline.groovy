import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.SystemCredentialsProvider
import com.cloudbees.plugins.credentials.domains.Domain
import hudson.plugins.git.BranchSpec
import hudson.plugins.git.GitSCM
import hudson.plugins.git.UserRemoteConfig
import jenkins.model.Jenkins
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import org.jenkinsci.plugins.workflow.job.WorkflowJob

def env = System.getenv()
def instance = Jenkins.get()

def knownHosts = env.get("JENKINS_GIT_KNOWN_HOSTS")
if (knownHosts) {
    def sshDir = new File(instance.getRootDir(), ".ssh")
    if (!sshDir.exists()) {
        sshDir.mkdirs()
    }
    sshDir.setReadable(true, true)
    sshDir.setWritable(true, true)
    sshDir.setExecutable(true, true)

    def knownHostsFile = new File(sshDir, "known_hosts")
    knownHostsFile.text = knownHosts + System.lineSeparator()
    knownHostsFile.setReadable(true, true)
    knownHostsFile.setWritable(true, true)
}

def credentialId = env.get("JENKINS_PIPELINE_CREDENTIALS_ID") ?: "scm-ssh-key"
def privateKeyFilePath = env.get("JENKINS_GIT_SSH_PRIVATE_KEY_FILE")
def privateKeyInline = env.get("JENKINS_GIT_SSH_PRIVATE_KEY")
def passphrase = env.get("JENKINS_GIT_SSH_PASSPHRASE") ?: ""
def username = env.get("JENKINS_PIPELINE_SSH_USERNAME") ?: "git"

String privateKey = null
if (privateKeyFilePath) {
    def privateKeyFile = new File(privateKeyFilePath)
    if (privateKeyFile.exists()) {
        privateKey = privateKeyFile.text
    } else {
        println "--> Jenkins SSH key file not found at ${privateKeyFilePath}; SCM credential will not be updated."
    }
} else if (privateKeyInline) {
    privateKey = privateKeyInline
}

if (privateKey) {
    def credentialsStore = SystemCredentialsProvider.getInstance().getStore()
    def credentialsDomain = Domain.global()
    def replacement = new BasicSSHUserPrivateKey(
        CredentialsScope.GLOBAL,
        credentialId,
        username,
        new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(privateKey),
        passphrase ?: null,
        "Seeded from Docker environment"
    )

    def existing = SystemCredentialsProvider.getInstance().getCredentials().find { it.id == credentialId }
    if (existing) {
        credentialsStore.updateCredentials(credentialsDomain, existing, replacement)
    } else {
        credentialsStore.addCredentials(credentialsDomain, replacement)
    }
    println "--> Jenkins SCM SSH credential '${credentialId}' is ready."
}

def pipelineJobName = env.get("JENKINS_PIPELINE_JOB_NAME") ?: "flutter-repo-pipeline"
def repoUrl = env.get("JENKINS_PIPELINE_REPO_URL") ?: env.get("JENKINS_JOB_REPO_URL")
def branch = env.get("JENKINS_PIPELINE_BRANCH") ?: env.get("JENKINS_JOB_BRANCH") ?: "main"
def scriptPath = env.get("JENKINS_PIPELINE_SCRIPT_PATH") ?: "Jenkinsfile"

if (!repoUrl) {
    println "--> JENKINS_PIPELINE_REPO_URL/JENKINS_JOB_REPO_URL not set; skipping pipeline job provisioning."
    return
}

def existingJob = instance.getItemByFullName(pipelineJobName)
if (existingJob && !(existingJob instanceof WorkflowJob)) {
    println "--> Existing item '${pipelineJobName}' is not a WorkflowJob; skipping pipeline provisioning."
    return
}

WorkflowJob job = existingJob ?: instance.createProject(WorkflowJob, pipelineJobName)
job.description = "Pipeline job provisioned from the Docker image. It loads ${scriptPath} from ${repoUrl}."

def userRemoteConfig = new UserRemoteConfig(repoUrl, null, null, privateKey ? credentialId : null)
def scm = new GitSCM(
    [userRemoteConfig],
    [new BranchSpec("*/${branch}")],
    false,
    [],
    null,
    null,
    []
)

def definition = new CpsScmFlowDefinition(scm, scriptPath)
definition.setLightweight(false)
job.setDefinition(definition)
job.disabled = false
job.save()

println "--> Jenkins pipeline job '${pipelineJobName}' now tracks ${repoUrl} (${branch}) using ${scriptPath}."
