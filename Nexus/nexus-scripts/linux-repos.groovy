import org.sonatype.nexus.repository.storage.WritePolicy

// === Ubuntu/Debian (APT) ===

// Hosted repo برای پکیج‌های داخلی
repository.createAptHosted(
    'ubuntu-hosted',
    WritePolicy.ALLOW
)

// Proxy repo برای mirror رسمی Ubuntu
repository.createAptProxy(
    'ubuntu-proxy',
    'http://archive.ubuntu.com/ubuntu'
)

// Group repo برای ترکیب hosted + proxy
repository.createAptGroup(
    'ubuntu-group',
    ['ubuntu-hosted', 'ubuntu-proxy']
)


// === CentOS/RedHat (YUM) ===

// Hosted repo برای پکیج‌های داخلی
repository.createYumHosted(
    'centos-hosted',
    WritePolicy.ALLOW,
    true   // deploy policy: allow redeploy
)

// Proxy repo برای mirror رسمی CentOS
repository.createYumProxy(
    'centos-proxy',
    'http://mirror.centos.org/centos/',
    true
)

// Group repo برای ترکیب hosted + proxy
repository.createYumGroup(
    'centos-group',
    ['centos-hosted', 'centos-proxy']
)
