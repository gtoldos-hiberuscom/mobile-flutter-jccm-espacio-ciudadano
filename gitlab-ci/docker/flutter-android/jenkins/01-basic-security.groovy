import hudson.security.FullControlOnceLoggedInAuthorizationStrategy
import hudson.security.HudsonPrivateSecurityRealm
import jenkins.model.Jenkins

def instance = Jenkins.get()
def marker = new File(instance.getRootDir(), ".flutter-android-ci-basic-security")

if (!marker.exists()) {
    def env = System.getenv()
    def adminUser = env.get("JENKINS_ADMIN_USER") ?: "admin"
    def adminPassword = env.get("JENKINS_ADMIN_PASSWORD") ?: "admin"
    def executors = (env.get("JENKINS_NUM_EXECUTORS") ?: "2") as int

    def realm = new HudsonPrivateSecurityRealm(false)
    realm.createAccount(adminUser, adminPassword)
    instance.setSecurityRealm(realm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    strategy.setAllowAnonymousRead(false)
    instance.setAuthorizationStrategy(strategy)
    instance.setNumExecutors(executors)

    instance.save()
    marker.text = "created\n"

    println "--> Jenkins admin user '${adminUser}' created. Override JENKINS_ADMIN_PASSWORD for non-local use."
}
